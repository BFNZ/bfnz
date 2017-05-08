class ChangeNameToTwoFieldsInTables < ActiveRecord::Migration
  def change
    remove_column :tables, :coordinator_name
    add_column :tables, :coordinator_first_name, :string
    add_column :tables, :coordinator_last_name, :string
  end
end
