class RefreshStudentMetricsJob
  include Sidekiq::Worker
  queue_as :default

  sidekiq_options retry: 3

  attr_reader :user

  def self.redis_key(user_id)
    @user = User.find_by(id: user_id)
    @user.role_scoped_cache_key(prefix: :refresh_student_metrics_job)
  end

  def self.enqueue(user_id)
    redis_key = redis_key(user_id)

    Sidekiq.redis do |conn|
      exists = conn.exists(redis_key) == 1
      Rails.logger.info("Redis key #{redis_key} exists? #{exists}")
      return Rails.logger.info("Job not enqueued because Redis key #{redis_key} already exists") if exists

      conn.set(redis_key, "true", ex: 3600)
      Rails.logger.info("Setting Redis key #{redis_key} and enqueuing job")
      perform_async(user_id)
    end
  end

  def perform(user_id)
    @user = User.find_by(id: user_id)
    return unless @user

    parent_batch = Sidekiq::Batch.new
    parent_batch.description = 'Calculate Success Metrics Batch'
    parent_batch.on(:success, "RefreshStudentMetricsJob#release_lock", 'user_id' => user_id)

    parent_batch.jobs do
      step1 = Sidekiq::Batch.new
      step1.description = 'Enrollment Login Info Update Batch'
      step1.on(:success, "RefreshStudentMetricsJob#on_successful_info_update", 'user_id' => user_id)
      step1.jobs do
        # TODO: Implement EnrollmentLoginInfoUpdateJob and uncomment this line
        EnrollmentLoginInfoUpdateJob.perform_async(user_id)
      end
    end
  end

  def on_successful_info_update(status, options)
    user_id = options['user_id']
    parent_batch = Sidekiq::Batch.new(status.parent_bid)

    @user ||= User.find_by(id: user_id)

    parent_batch.jobs do
      step2 = Sidekiq::Batch.new
      step2.description = 'Calculate Success Metrics Batch'
      step2.on(:success, "RefreshStudentMetricsJob#bust_user_cache", 'user_id' => user_id)
      step2.jobs do
        enqueue_calculate_success_metrics_jobs
      end
    end
  end

  private

  def enqueue_calculate_success_metrics_jobs
    enrollments = fetch_enrollments_for_success_metrics
    enrollments.find_in_batches(batch_size: 1000) do |enrollment_batch|
      enrollment_batch.each do |enrollment|
        CalculateSuccessMetricsJob.enqueue(enrollment.id)
      end
    end
  end

  def fetch_enrollments_for_success_metrics
    base_scope = Enrollment.where(role: 'student', status: 'active')
                           .where('enrollments.end_date >= ?', 1.day.ago)
                           .joins(:section)
                           .where.not('sections.title LIKE ?', 'Syn%')

    user&.acting_as_org_admin? ? base_scope : base_scope.where(user_id: user.my_students)
  end

  def bust_user_cache(_status, options)
    user_id = options['user_id']

    user = User.find_by(id: user_id)
    return unless user

    %i[metrics_map student_performance_buckets].each do |prefix|
      Rails.cache.delete(user.role_scoped_cache_key(prefix:))
    end

    flash = ActionDispatch::Flash::FlashHash.new
    flash[:success] = "Background jobs have finished, please refresh the page to see the updated results."

    Turbo::StreamsChannel.broadcast_update_to(
      "alerts",
      target: "alerts",
      partial: "shared/alerts",
      locals: { flash: flash }
    )

    Turbo::StreamsChannel.broadcast_update_to(
      "sync_metrics_button",
      target: "sync_metrics_button",
      partial: "dashboard/teacher/enabled_sync_metrics_button"
    )
  end

  def release_lock(_status, options)
    user_id = options['user_id']
    Sidekiq.redis { |conn| conn.del(self.class.redis_key(user_id)) }
  end
end

