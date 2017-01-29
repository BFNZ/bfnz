class Admin::Orders::CsvView
  def initialize(order)
    @order = order
    @customer = order.customer
  end

  delegate :first_name, :last_name, :address, :suburb, :city_town, :phone,
  :email, :title, :ta, :post_code, :tertiary_institution,
  :further_contact_requested, :admin_notes, to: :customer

  delegate :id, :method_of_discovery, :created_at, :ip_address,
  :method_received, :shipment_id, :item_codes, to: :order

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
    customer.tertiary_student? ? 'Yes' : 'No'
  end

  def creator_name
    order.created_by.try(:name)
  end

  def creator_email
    order.created_by.try(:email)
  end

  private

  attr_reader :order, :customer

end
