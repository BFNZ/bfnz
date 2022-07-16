class Admin::OrderPresenter
  def initialize(order)
    @order = order
  end

  delegate :id, to: :order, prefix: true
  delegate :customer, :customer_id, to: :order
  delegate :first_name, :last_name, to: :customer

  def order_number
    "##{customer_id}.#{order.id}"
  end

  def created
    "#{order.created_at.to_fs(:display)} by #{created_by}"
  end

  def items
    order.items.map(&:title).join("<br>").html_safe
  end

  def shipped_at
    order.shipped_at.to_fs(:display) if order.shipped?
  end

  def further_contact_requested
    customer.further_contact_requested.humanize
  end

  def pxid
    customer.pxid.presence
  end

  private

  attr_reader :order

  def created_by
    order.created_by ? order.created_by.name : order.ip_address
  end
end
