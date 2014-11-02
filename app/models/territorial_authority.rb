class TerritorialAuthority < ActiveRecord::Base
  belongs_to :coordinator, class_name: 'User'

  validates :name, presence: true
  validates :code, :addressfinder_name, uniqueness: true, presence: true
end
