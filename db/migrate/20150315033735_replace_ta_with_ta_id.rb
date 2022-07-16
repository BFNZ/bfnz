class ReplaceTaWithTaId < ActiveRecord::Migration[7.0]
  def up
    add_column :orders, :territorial_authority_id, :integer
    add_index :orders, :territorial_authority_id

    Order.where('ta is not null').where(territorial_authority_id: nil).each do |order|
      if ta = TerritorialAuthority.find_by_addressfinder_name(order.ta)
        order.update_column(:territorial_authority_id, ta.id)
      end
    end
  end

  def down
    remove_index :orders, :territorial_authority_id
    remove_column :orders, :territorial_authority_id
  end
end
