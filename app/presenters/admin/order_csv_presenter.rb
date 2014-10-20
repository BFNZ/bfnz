class Admin::OrderCsvPresenter
  def initialize(order)
    @order = order
  end

  delegate :id, :first_name, :last_name, :address, :suburb, :city_town, :phone,
           :email, :method_of_discovery, :created_at, :title, :ip_address, :ta,
           :post_code, :method_received, :tertiary_institution, :shipment_id,
           to: :order

  def created_at
    order.created_at.to_s(:display)
  end

  def items
    order.items.map(&:title).join(", ")
  end

  def shipped_at
    order.shipped_at.to_s(:display) if order.shipped?
  end

  def tertiary_student
    order.tertiary_student? ? 'Yes' : 'No'
  end

  private

  attr_reader :order
end
