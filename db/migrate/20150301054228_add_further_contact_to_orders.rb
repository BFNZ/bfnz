class AddFurtherContactToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :further_contact_requested, :boolean, default: false
  end
end
