class Shipment < ApplicationRecord
  has_many :orders

  def self.create_for_orders(orders)
    self.transaction do
      shipment = self.create!
      orders.update_all(shipment_id: shipment.id)
      shipment
    end
  end

  def filename
    "labels_#{created_at.to_s(:csv)}"
  end

end
