class Admin::CreateOrderService
  def initialize(current_user, params)
    @user = current_user
    @params = params
  end

  def save
    order.save
  end

  def order
    @order ||= Order.new(order_params.merge(:created_by => @user))
  end

  private

  def order_params
    @params.require(:order).
      permit(:title, :first_name, :last_name, :address, :suburb, :city_town,
             :post_code, :pxid, :ta, :phone, :email, :tertiary_student,
             :tertiary_institution, :admin_notes, :item_ids => [])
  end
end
