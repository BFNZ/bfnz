class Admin::OrderPresenter
  def initialize(order)
    @order = order
  end

  delegate :id, :first_name, :last_name, to: :order

  def created
    "#{order.created_at.to_s(:display)} by #{created_by}"
  end

  def items
    order.items.map(&:title).join(", ")
  end

  def shipped_at
    order.shipped_at.to_s(:display) if order.shipped?
  end

  private

  attr_reader :order

  def created_by
    order.created_by ? order.created_by.email : order.ip_address
  end
end
