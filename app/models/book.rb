class Book < ApplicationRecord
  validates :title, presence: true
  validates :code, presence: true
  validates :ISBN, presence: true
  validates :author, presence: true

  has_many :inventories
end
