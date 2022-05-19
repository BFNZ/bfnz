class RemoveCodeFromTables < ActiveRecord::Migration[7.0]
  def change
    remove_column :tables, :code, :string
  end
end
