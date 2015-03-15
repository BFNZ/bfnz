class CreateContactLists < ActiveRecord::Migration
  def change
    create_table :contact_lists do |t|
      t.integer :territorial_authority_id, null: false
      t.timestamps
    end

    add_index :contact_lists, :territorial_authority_id

    add_column :orders, :contact_list_id, :integer
    add_index :orders, :contact_list_id
  end
end
