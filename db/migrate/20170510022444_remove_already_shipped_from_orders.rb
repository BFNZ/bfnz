class RemoveAlreadyShippedFromOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :shipped_before_order, :boolean
  end
end
