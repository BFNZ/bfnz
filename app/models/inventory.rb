class Inventory < ApplicationRecord
  belongs_to :book

  def stock_in?
    entry_type == 'Stock In'
  end
  
end
