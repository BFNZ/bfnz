class Admin::OrderPresenter
  def initialize(order)
    @order = order
  end

  delegate :id, :first_name, :last_name, to: :order

  def created
    "#{order.created_at.to_s(:display)} by #{created_by}"
  end

  def items
    order.items.map(&:title).join("<br>").html_safe
  end

  def shipped_at
    order.shipped_at.to_s(:display) if order.shipped?
  end

  def row_class
    'duplicate' if order.duplicate?
  end

  def further_contact_requested
    order.further_contact_requested? ? "Yes" : "No"
  end

  private

  attr_reader :order

  def created_by
    order.created_by ? order.created_by.name : order.ip_address
  end
end