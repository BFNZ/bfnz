class CreateInventories < ActiveRecord::Migration[7.0]
  def change
    create_table :inventories do |t|
      t.string :entry_type
      t.date :date
      t.integer :book_id
      t.integer :quantity
      t.decimal :unit_cost

      t.timestamps
    end
  end
end
