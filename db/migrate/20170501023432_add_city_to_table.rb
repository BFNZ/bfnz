class AddCityToTable < ActiveRecord::Migration[7.0]
  def change
    add_column :tables, :city, :string
  end
end
