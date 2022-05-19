class TerritorialAuthority < ApplicationRecord
  belongs_to :coordinator, class_name: 'User', optional: true

  validates :name, presence: true
  validates :code, :addressfinder_name, uniqueness: true, presence: true
end
