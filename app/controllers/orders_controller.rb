class OrdersController < ApplicationController
  before_filter :setup_order_form

  def new
  end

  def create
    order_service = CreateOrderService.new(request, @order_form)
    if order_service.save
      redirect_to root_path, notice: "Thanks, your order will be shipped as soon as possible"
    else
      render :new
    end
  end

  private

  def setup_order_form
    @order_form ||= CustomerAndOrderForm.new(params[:customer_and_order_form] || {})
  end
end
