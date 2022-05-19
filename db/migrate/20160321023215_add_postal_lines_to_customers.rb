class AddPostalLinesToCustomers < ActiveRecord::Migration[7.0]
  def change
    add_column :customers, :postal_line_1, :string, limit: 255
    add_column :customers, :postal_line_2, :string, limit: 255
    add_column :customers, :postal_line_3, :string, limit: 255
    add_column :customers, :postal_line_4, :string, limit: 255
    add_column :customers, :postal_line_5, :string, limit: 255
    add_column :customers, :postal_line_6, :string, limit: 255
  end
end
