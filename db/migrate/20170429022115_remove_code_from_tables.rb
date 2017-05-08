class RemoveCodeFromTables < ActiveRecord::Migration
  def change
    remove_column :tables, :code, :string
  end
end
