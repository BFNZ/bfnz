class CreateTerritorialAuthorities < ActiveRecord::Migration
  def change
    create_table :territorial_authorities do |t|
      t.string :name, null: false
      t.integer :code, null: false
      t.string :addressfinder_name, null: false
      t.integer :coordinator_id
      t.timestamps
    end

    add_index :territorial_authorities, :addressfinder_name
    add_index :territorial_authorities, :coordinator_id
  end
end
