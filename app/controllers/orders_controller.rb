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

  def create_table_order
    order_service = CreateOrderService.new(request, @order_form)
    if order_service.save
      redirect_to table_path, notice: "Form submitted successfully. Have a great day!" # better wording for the notice?
    else
      render :new # how to get this to the table_new?
    end
  end

  private

  def setup_order_form
    @order_form ||= CustomerAndOrderForm.new(params[:customer_and_order_form] || {})
  end
end
