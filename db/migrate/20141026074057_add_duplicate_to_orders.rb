class AddDuplicateToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :duplicate, :boolean, default: false
    add_index :orders, :duplicate
  end
end
