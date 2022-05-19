class AddShippedBeforeOrderToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :shipped_before_order, :boolean, default: false
  end
end
