class CreateOrderService
  def initialize(controller)
    @controller = controller
  end

  def save
    order.save
  end

  private

  def order
    @order ||= Order.new(order_params.merge(ip_address: ip_address))
  end

  def order_params
    @controller.params.require(:order).permit(:title, :first_name, :last_name, :address, :suburb, :city_town, :post_code, :pxid, :ta, :phone, :email, :tertiary_student, :tertiary_institution)
  end

  def ip_address
    @controller.request.remote_ip
  end
end
