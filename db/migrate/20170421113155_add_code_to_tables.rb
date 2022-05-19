class AddCodeToTables < ActiveRecord::Migration[7.0]
  def change
    add_column :tables, :code, :string
  end
end
