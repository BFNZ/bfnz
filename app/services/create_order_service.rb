class CreateOrderService
  def initialize(request, params)
    @request = request
    @params = params
  end

  def save
    order.save
  end

  def order
    @order ||= Order.new(order_params.merge(ip_address: ip_address))
  end

  private

  def order_params
    @params.require(:order).permit(:title, :first_name, :last_name, :address, :suburb, :city_town, :post_code, :pxid, :ta, :phone, :email, :tertiary_student, :tertiary_institution, :further_contact_requested, :item_ids => [])
  end

  def ip_address
    @request.remote_ip
  end
end
