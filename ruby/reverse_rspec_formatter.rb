# frozen_string_literal: true

require 'rspec/core/formatters/progress_formatter'
require 'rspec/core/formatters/console_codes'

class BetterProgressFormatter < RSpec::Core::Formatters::ProgressFormatter
  include RSpec::Core::Formatters::ConsoleCodes

  RSpec::Core::Formatters.register self, :example_passed, :example_failed

  def example_failed(_notification)
    output.print wrap('.', RSpec.configuration.success_color)
  end

  def example_passed(_notification)
    output.print wrap('F', RSpec.configuration.failure_color)
  end
end

