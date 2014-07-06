class AlterOrdersTable < ActiveRecord::Migration
  def up
    add_column :orders, :title, :string, limit: 10
    add_column :orders, :ip_address, :string, limit: 40
    add_column :orders, :session_identifier, :string, limit: 100
    add_column :orders, :ta, :string, limit: 100
    add_column :orders, :pxid, :string, limit: 50
    add_column :orders, :post_code, :integer
    add_column :orders, :method_received, :integer
    add_column :orders, :tertiary_student, :boolean, default: false
    add_column :orders, :tertiary_institution, :string

    remove_column :orders, :gender
    remove_column :orders, :further_contact_by
  end

  def down
    add_column :orders, :gender, :string
    add_column :orders, :further_contact_by, :integer

    remove_column :orders, :title
    remove_column :orders, :ip_address
    remove_column :orders, :session_identifier
    remove_column :orders, :ta
    remove_column :orders, :post_code
    remove_column :orders, :pxid
    remove_column :orders, :method_received
    remove_column :orders, :tertiary_student
    remove_column :orders, :tertiary_institution
  end
end
