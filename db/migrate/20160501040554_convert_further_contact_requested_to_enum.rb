class ConvertFurtherContactRequestedToEnum < ActiveRecord::Migration[7.0]
  def up
    remove_index :customers, :further_contact_requested
    remove_column :customers, :further_contact_requested
    add_column :customers, :further_contact_requested, :integer, default: 0
    add_index :customers, :further_contact_requested
  end

  def down
    remove_index :customers, :further_contact_requested
    remove_column :customers, :further_contact_requested
    add_column :customers, :further_contact_requested, :boolean
    add_index :customers, :further_contact_requested
  end
end
