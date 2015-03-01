class AddIndexToFurtherContactRequested < ActiveRecord::Migration
  def change
    add_index :orders, :further_contact_requested
  end
end
