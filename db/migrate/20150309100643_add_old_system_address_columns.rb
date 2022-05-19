class AddOldSystemAddressColumns < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :old_system_address, :string, limit: 100
    add_column :orders, :old_system_suburb, :string, limit: 100
    add_column :orders, :old_system_city_town, :string, limit: 100
  end
end
