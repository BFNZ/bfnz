class Admin::LabelPresenter
  def initialize(shipment)
    @shipment = shipment
  end

  def headers
    ["Code", "Title", "First name", "Last name", "Address 1", "Address 2", "Address 3", "Address 4", "Address 5", "Address 6", "Full Address"]
  end

  def each_label(&block)
    @shipment.orders.order('id').each do |order|
      yield Admin::LabelCsvPresenter.new(order)
    end
  end
end
