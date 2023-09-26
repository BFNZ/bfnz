class Api::V1::OrdersController < Api::BaseController
  before_action :authenticate!

  def validate
    order = CustomerAndOrderForm.new(order_params)
    response = order.valid? ? { success: true } : { success: false, errors: order.errors.full_messages }
    render(json: response, status: (order.valid? ? 200 : 400))
  end

  def create
    order = CustomerAndOrderForm.new(order_params)
    order_service = CreateOrderService.new(request, order)
    if !order.errors.present? && order_service.save
      render('/api/v1/order', locals: { order: order_service.order.reload })
    else
      render(json: { success: false, errors: order.errors.full_messages }, status: 400)
    end
  end

  private

  def order_params
    params.require(:order).permit(:title, :first_name, :last_name, :address, :suburb, :city_town, :post_code, :phone,
                                  :email, :further_contact_requested, item_ids: [])
  end
end
