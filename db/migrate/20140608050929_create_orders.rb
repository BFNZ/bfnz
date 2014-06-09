class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :historical_subscriber_id
      t.references :place
      t.references :shipment
      t.string :first_name
      t.string :last_name
      t.string :address
      t.string :suburb
      t.string :city_town
      t.string :phone
      t.string :email
      t.string :gender
      t.text :admin_notes
      t.text :coordinator_notes
      t.integer :method_of_discovery
      t.integer :further_contact_by
      t.timestamps
    end

    add_index :orders, :first_name
    add_index :orders, :last_name
    add_index :orders, :address
    add_index :orders, :suburb
    add_index :orders, :city_town
    add_index :orders, :phone
    add_index :orders, :email
    add_index :orders, :shipment_id
    add_index :orders, :place_id
  end
end
