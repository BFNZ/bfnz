class Admin::DuplicateOrderPresenter
  def initialize(id)
    @order = Order.find id
  end

  delegate :id, :address, :email, :phone, to: :order

  def created
    "#{order.created_at.to_s(:display)} by #{created_by}"
  end

  def shipped
    "Shipped: #{order.shipped_at.to_s(:display)}" if order.shipped?
  end

  def name
    "#{order.first_name} #{order.last_name}"
  end

  def items
    order.item_codes
  end

  def duplicates
    order.duplicates
  end

  def marked_as_duplicate?
    order.duplicate?
  end

  private

  attr_reader :order

  def created_by
    order.created_by ? order.created_by.name : order.ip_address
  end
end
