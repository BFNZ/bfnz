class Admin::LabelCsvPresenter
  def initialize(order)
    @order = order
  end

  def row
    [order_code, title, first_name, last_name, address]
  end

  private

  attr_reader :order

  delegate :title, :first_name, :last_name, :address, to: :customer

  def order_code
    "#{order.item_codes}-#{order.id}"
  end

  def customer
    order.customer
  end
end
