class UpdateOrderService
  attr_reader :order

  def initialize(request, params)
    @request = request
    @params = params
    @order = Order.find(params[:id])
  end

  def save
    order.update(order_params)
  end

  private

  def order_params
    @params.require(:order).permit(:title, :first_name, :last_name, :address, :suburb, :city_town, :post_code, :pxid, :dpid, :x, :y,  :ta, :phone, :email, :method_received, :method_of_discovery, :tertiary_student, :tertiary_institution, :item_ids => [])
  end

  def ip_address
    @request.remote_ip
  end
end
