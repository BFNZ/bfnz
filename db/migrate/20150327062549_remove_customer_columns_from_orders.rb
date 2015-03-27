class RemoveCustomerColumnsFromOrders < ActiveRecord::Migration
  def up
    remove_column :orders, :territorial_authority_id
    remove_column :orders, :contact_list_id
    remove_column :orders, :first_name
    remove_column :orders, :last_name
    remove_column :orders, :address
    remove_column :orders, :suburb
    remove_column :orders, :city_town
    remove_column :orders, :post_code
    remove_column :orders, :ta
    remove_column :orders, :pxid
    remove_column :orders, :phone
    remove_column :orders, :email
    remove_column :orders, :title
    remove_column :orders, :tertiary_student
    remove_column :orders, :tertiary_institution
    remove_column :orders, :further_contact_requested
    remove_column :orders, :historical_subscriber_id
    remove_column :orders, :old_system_address
    remove_column :orders, :old_system_suburb
    remove_column :orders, :old_system_city_town
  end

  def down
    add_column :orders, :territorial_authority_id, :integer
    add_column :orders, :contact_list_id, :integer
    add_column :orders, :first_name, :string
    add_column :orders, :last_name, :string
    add_column :orders, :address, :string
    add_column :orders, :suburb, :string
    add_column :orders, :city_town, :string
    add_column :orders, :post_code, :string
    add_column :orders, :ta, :string
    add_column :orders, :pxid, :string
    add_column :orders, :phone, :string
    add_column :orders, :email, :string
    add_column :orders, :title, :string
    add_column :orders, :tertiary_student, :boolean
    add_column :orders, :tertiary_institution, :string
    add_column :orders, :further_contact_requested, :boolean
    add_column :orders, :historical_subscriber_id, :integer
    add_column :orders, :old_system_address, :string
    add_column :orders, :old_system_suburb, :string
    add_column :orders, :old_system_city_town, :string

    Order.where('customer_id is not null').each do |order|
      customer = order.customer
      order.update_attributes(title: customer.title,
                              first_name: customer.first_name,
                              last_name: customer.last_name,
                              address: customer.address,
                              suburb: customer.suburb,
                              city_town: customer.city_town,
                              post_code: customer.post_code,
                              ta: customer.ta,
                              pxid: customer.pxid,
                              phone: customer.phone,
                              email: customer.email,
                              territorial_authority_id: customer.territorial_authority_id,
                              contact_list_id: customer.contact_list_id,
                              further_contact_requested: customer.further_contact_requested,
                              tertiary_student: customer.tertiary_student,
                              tertiary_institution: customer.tertiary_institution,
                              historical_subscriber_id: customer.old_subscriber_id,
                              old_system_address: customer.old_system_address,
                              old_system_suburb: customer.old_system_suburb,
                              old_system_city_town: customer.old_system_city_town)
    end
  end
end
