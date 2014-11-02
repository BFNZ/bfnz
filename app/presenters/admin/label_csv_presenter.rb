class Admin::LabelCsvPresenter
  def initialize(order)
    @order = order
  end

  delegate :title, :first_name, :last_name, :address, to: :order

  def order_code
    "#{order.item_codes}-#{order.id}"
  end

  private

  attr_reader :order
end
