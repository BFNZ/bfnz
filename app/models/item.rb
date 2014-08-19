class Item < ActiveRecord::Base
  has_and_belongs_to_many :orders

  validates :title, presence: true
  validates :code, uniqueness: true

  scope :active, ->{ where(deactivated_at: nil) }
end
