class User < ActiveRecord::Base
  acts_as_authentic do |config|
    config.crypto_provider = Authlogic::CryptoProviders::BCrypt
  end

  has_many :territorial_authorities, foreign_key: :coordinator_id

  scope :coordinators, -> { where(admin: false) }
  scope :unassigned_coordinators, -> {
    coordinators.
    joins('LEFT OUTER JOIN territorial_authorities ON territorial_authorities.coordinator_id = users.id').
    where('territorial_authorities.coordinator_id IS NULL')
  }

  validates :name, :email, presence: true

  def new_contacts
    Customer.contactable.for_districts(territorial_authorities.pluck(:id))
  end
end
