class AddIndexToFurtherContactRequested < ActiveRecord::Migration[7.0]
  def change
    add_index :orders, :further_contact_requested
  end
end
