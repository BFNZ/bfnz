class AddOldSystemAddressColumns < ActiveRecord::Migration
  def change
    add_column :orders, :old_system_address, :string, limit: 100
    add_column :orders, :old_system_suburb, :string, limit: 100
    add_column :orders, :old_system_city_town, :string, limit: 100
  end
end
