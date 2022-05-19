class CreateCustomers < ActiveRecord::Migration[7.0]
  def up
    create_table :customers do |t|
      t.integer :territorial_authority_id
      t.integer :contact_list_id
      t.integer :created_by_id
      t.integer :updated_by_id
      t.string :first_name
      t.string :last_name
      t.string :address
      t.string :suburb
      t.string :city_town
      t.string :post_code
      t.string :ta
      t.string :pxid
      t.string :phone
      t.string :email
      t.string :title
      t.boolean :tertiary_student
      t.string :tertiary_institution
      t.text :admin_notes
      t.text :coordinator_notes
      t.boolean :further_contact_requested
      t.integer :old_subscriber_id
      t.string :old_system_address
      t.string :old_system_suburb
      t.string :old_system_city_town
      t.timestamps
    end

    add_index :customers, :territorial_authority_id
    add_index :customers, :contact_list_id
    add_index :customers, :created_by_id
    add_index :customers, :updated_by_id
    add_index :customers, :first_name
    add_index :customers, :last_name
    add_index :customers, :address
    add_index :customers, :suburb
    add_index :customers, :city_town
    add_index :customers, :phone
    add_index :customers, :email
    add_index :customers, :further_contact_requested

    add_column :orders, :customer_id, :integer
    add_index :orders, :customer_id

    Order.where(customer_id: nil).each do |order|
      customer = Customer.create!(title: order.title,
                                  first_name: order.first_name,
                                  last_name: order.last_name,
                                  address: order.address,
                                  suburb: order.suburb,
                                  city_town: order.city_town,
                                  post_code: order.post_code,
                                  ta: order.ta,
                                  pxid: order.pxid,
                                  phone: order.phone,
                                  email: order.email,
                                  territorial_authority_id: order.territorial_authority_id,
                                  contact_list_id: order.contact_list_id,
                                  created_by_id: order.created_by_id,
                                  updated_by_id: order.updated_by_id,
                                  further_contact_requested: order.further_contact_requested,
                                  tertiary_student: order.tertiary_student,
                                  tertiary_institution: order.tertiary_institution,
                                  admin_notes: order.admin_notes,
                                  coordinator_notes: order.coordinator_notes,
                                  old_subscriber_id: order.historical_subscriber_id,
                                  old_system_address: order.old_system_address,
                                  old_system_suburb: order.old_system_suburb,
                                  old_system_city_town: order.old_system_city_town)
      order.update_column(:customer_id, customer.id)
    end
  end

  def down
    drop_table :customers
    remove_column :orders, :customer_id
  end
end
