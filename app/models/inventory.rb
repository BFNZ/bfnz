class Inventory < ApplicationRecord
  validates :entry_type, presence: true
  validates :date, presence: true
  validates :book_id, presence: true
  validates :quantity, presence: true
  validates :unit_cost, presence: true, if: :stock_in?

  belongs_to :book

  private

  def stock_in?
    entry_type == 'Stock In'
  end
end