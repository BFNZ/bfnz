class AddParentIdToCustomers < ActiveRecord::Migration[7.0]
  def change
    add_column :customers, :parent_id, :integer
    add_index :customers, :parent_id
  end
end
