class AddBadAddressColumnToCustomers < ActiveRecord::Migration[7.0]
  def change
    add_column(:customers, :bad_address, :boolean, default: false)
  end
end
