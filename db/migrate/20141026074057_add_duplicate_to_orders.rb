class AddDuplicateToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :duplicate, :boolean, default: false
    add_index :orders, :duplicate
  end
end
