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
      send_confirmation_email
      true
    else
      false
    end
  end

  def order
    @order ||= customer.orders.build(@form.order_attributes.merge(ip_address: ip_address,
                                                                  method_received: method_received,
                                                                  method_of_discovery: @table_id.present? ? :table_disc : nil,
                                                                  shipped_before_order: @table_id.present?,
                                                                  table_id: @table_id
                                                                  ))
  end

  def customer
    @customer ||= Customer.new(@form.customer_attributes)
  end

  private

  def ip_address
    @request.remote_ip
  end

  def method_received
    @table_id ? :table : :internet
  end

  def send_confirmation_email
    OrderMailer.confirmation_email(order).deliver if customer.has_email?
  end
end
