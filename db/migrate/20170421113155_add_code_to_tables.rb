class AddCodeToTables < ActiveRecord::Migration
  def change
    add_column :tables, :code, :string
  end
end
