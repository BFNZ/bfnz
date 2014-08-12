class Item < ActiveRecord::Base

  validates :title, presence: true
  validates :code, uniqueness: true

  scope :active, ->{ where(deactivated_at: nil) }
end
