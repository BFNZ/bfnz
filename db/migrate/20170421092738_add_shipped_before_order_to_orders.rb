class AddShippedBeforeOrderToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :shipped_before_order, :boolean, default: false
  end
end
