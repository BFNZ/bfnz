class Admin::OrderPresenter
  def initialize(order)
    @order = order
  end

  delegate :id, :first_name, :last_name, to: :order

  def created_at
    order.created_at.to_s(:display)
  end

  def items
    order.items.map(&:title).join(", ")
  end

  def shipped_at
    order.shipped_at.to_s(:display) if order.shipped?
  end

  private

  attr_reader :order
end
