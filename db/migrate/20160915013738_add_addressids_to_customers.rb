class AddAddressidsToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :dpid, :string
    add_column :customers, :x,  :decimal, {:precision=>10, :scale=>6}
    add_column :customers, :y,  :decimal, {:precision=>10, :scale=>6}
  end
end
