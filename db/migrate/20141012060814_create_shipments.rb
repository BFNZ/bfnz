class CreateShipments < ActiveRecord::Migration
  def change
    create_table :shipments do |t|
      t.timestamps
    end

    add_index :shipments, :created_at
  end
end
