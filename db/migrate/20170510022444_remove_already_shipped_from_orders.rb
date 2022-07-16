class RemoveAlreadyShippedFromOrders < ActiveRecord::Migration[7.0]
  def change
    remove_column :orders, :shipped_before_order, :boolean
  end
end
