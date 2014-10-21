class Admin::LabelPresenter
  def self.for_shipment(shipment)
    shipment.orders.order('id').map { |order| Admin::LabelCsvPresenter.new(order) }
  end
end
