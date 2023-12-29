class CreateInventories < ActiveRecord::Migration[7.0]
  def change
    create_table :inventories do |t|
      t.string :entry_type
      t.date :date
      t.string :book_id
      t.integer :quantity
      t.decimal :unit_cost
      t.string :person_name

      t.timestamps
    end
  end
end
