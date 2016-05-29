class Admin::LabelCsvPresenter
  def initialize(order)
    @order = order
  end

  def row
    [order_code, title, first_name, last_name, postal_line_1, postal_line_2,
     postal_line_3, postal_line_4, postal_line_5, postal_line_6, address]
  end

  private

  attr_reader :order

  delegate :title, :first_name, :last_name, :postal_line_1, :postal_line_2,
           :postal_line_3, :postal_line_4, :postal_line_5, :postal_line_6,
           :address, to: :customer

  def order_code
    "#{order.item_codes}-#{order.id}"
  end

  def customer
    order.customer
  end
end
