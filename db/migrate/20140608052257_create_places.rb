class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :name, null: false
      t.references :district, null: false
      t.references :coordinator
      t.timestamps
    end

    add_index :places, :district_id
    add_index :places, :coordinator_id
  end
end
