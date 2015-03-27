class Admin::ShippableOrderPresenter
  def initialize(order)
    @order = order
  end

  delegate :id, :potential_duplicates, to: :order
  delegate :full_name, :address, :email, :phone, to: :customer

  def created
    "#{order.created_at.to_s(:display)} by #{created_by}"
  end

  def items
    order.item_codes
  end

  def marked_as_duplicate?
    order.duplicate?
  end

  private

  attr_reader :order

  def customer
    order.customer
  end

  def created_by
    order.created_by ? order.created_by.name : order.ip_address
  end
end
