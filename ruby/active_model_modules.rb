class Dummy
  include ActiveModel::Model

  # not included in ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Dirty
  include ActiveModel::Serialization

  validates :name, presence: true
  attribute :name, :string
end
