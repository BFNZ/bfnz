class AddFurtherContactToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :further_contact_requested, :boolean, default: false
  end
end
