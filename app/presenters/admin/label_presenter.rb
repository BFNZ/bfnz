class Admin::LabelPresenter
  def initialize(shipment)
    @shipment = shipment
  end

  def headers
    ["Code", "Title", "First name", "Last name", "Address"]
  end

  def each_label(&block)
    @shipment.orders.order('id').each do |order|
      yield Admin::LabelCsvPresenter.new(order)
    end
  end
end
