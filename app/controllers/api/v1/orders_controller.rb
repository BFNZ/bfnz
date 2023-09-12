class Api::V1::OrdersController < Api::BaseController
  before_action :authenticate!

  def validate
    order = CustomerAndOrderForm.new(order_params)
    response = order.valid? ? { success: true } : { success: false, errors: order.errors.full_messages }
    render(json: response, status: (order.valid? ? 200 : 400))
  end

  private

  def order_params
    # have to check - :tertiary_student, :tertiary_institution, :confirm_personal_order, :pxid, :dpid, :x, :y, :ta
    params.require(:order).permit(:title, :first_name, :last_name, :address, :suburb, :city_town, :post_code, :phone, :email, :further_contact_requested, item_ids: [])
  end
end
