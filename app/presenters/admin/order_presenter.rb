class Admin::OrderPresenter
  def initialize(order)
    @order = order
  end

  delegate :id, :first_name, :last_name, to: :order

  def items
    order.items.map(&:title).join(", ")
  end

  def shipped?
    order.shipped? ? "Yes" : "No"
  end

  private

  attr_reader :order
end
