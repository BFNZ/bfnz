class Admin::UpdateOrderService
  attr_reader :order

  def initialize(current_user, params)
    @user = current_user
    @params = params
    @order = Order.find(params[:id])
  end

  def save
    order.update(order_params.merge(:updated_by => @user))
  end

  private

  def order_params
    @params.require(:order).
      permit(:title, :first_name, :last_name, :address, :suburb, :city_town,
             :post_code, :pxid, :ta, :phone, :email, :method_received,
             :method_of_discovery, :tertiary_student, :tertiary_institution,
             :admin_notes, :further_contact_requested, :item_ids => [])
  end
end
