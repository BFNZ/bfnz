class CreateOrderService
  def initialize(request, form, table_id=nil)
    @request = request
    @form = form
    @table_id = table_id
  end

  def save
    if @form.valid?
      customer.save!
      order.save!
      create_shipment
      send_confirmation_email
      true
    else
      false
    end
  end

  def order
    attrs = {
      ip_address:,
      method_received:,
      method_of_discovery: @table_id.present? ? :table_disc : nil,
      table_id: @table_id,
      received_in_person: !!@table_id
    }
    order_attrs = @form.order_attributes.merge(attrs)
    @order ||= customer.orders.build(order_attrs)
  end

  def customer
    @customer ||= Customer.new(@form.customer_attributes)
  end

  private

  def create_shipment
    if order.received_in_person?
      Shipment.create_for_orders(Order.where(id: order.id))
    end
    true
  end

  def ip_address
    @request.remote_ip
  end

  def method_received
    @table_id ? :table : :internet
  end

  def send_confirmation_email
    OrderMailer.confirmation_email(order).deliver_now if customer.has_email?
  end
end
