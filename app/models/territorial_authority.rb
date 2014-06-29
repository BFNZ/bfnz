class TerritorialAuthority < ActiveRecord::Base
  validates :name, presence: true
  validates :code, :addressfinder_name, uniqueness: true, presence: true
end
