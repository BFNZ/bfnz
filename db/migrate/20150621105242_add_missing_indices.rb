class AddMissingIndices < ActiveRecord::Migration
  def change
    add_index :cancelled_order_events, :cancelled_by_id
    add_index :cancelled_order_events, :customer_id
    add_index :items_orders, :item_id
    add_index :items_orders, :order_id
#    add_index :orders, :created_by_id
#    add_index :orders, :updated_by_id
  end
end
