class AddBadAddressColumnToCustomers < ActiveRecord::Migration
  def change
    add_column(:customers, :bad_address, :boolean, default: false)
  end
end
