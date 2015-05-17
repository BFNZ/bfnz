class CreateCancelledOrderEvents < ActiveRecord::Migration
  def change
    create_table :cancelled_order_events do |t|
      t.integer :cancelled_by_id
      t.integer :customer_id
      t.text :order_details
      t.timestamps
    end
  end
end
