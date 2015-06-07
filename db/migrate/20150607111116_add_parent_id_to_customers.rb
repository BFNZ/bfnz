class AddParentIdToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :parent_id, :integer
    add_index :customers, :parent_id
  end
end
