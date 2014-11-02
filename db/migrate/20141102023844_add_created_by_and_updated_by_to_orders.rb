class AddCreatedByAndUpdatedByToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :created_by_id, :integer
    add_column :orders, :updated_by_id, :integer

    add_index :orders, :created_by_id
    add_index :orders, :updated_by_id
  end
end
