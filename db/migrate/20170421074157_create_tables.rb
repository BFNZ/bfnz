class CreateTables < ActiveRecord::Migration[7.0]
  def change
    create_table :tables do |t|
      t.string :coordinator_name
      t.string :coordinator_phone
      t.string :coordinator_email
      t.text :location
      t.timestamps
    end

    add_reference :orders, :table, foreign_key: true
  end
end
