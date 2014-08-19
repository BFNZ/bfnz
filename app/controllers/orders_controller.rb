class OrdersController < ApplicationController
  def new
    @order = Order.new
    @items = Item.active
  end

  def create
    order_service = CreateOrderService.new(request, params)
    if order_service.save
      redirect_to root_path, notice: "Thanks, your order will be shipped as soon as possible"
    else
      @order = order_service.order
      @items = Item.active
      render :new
    end
  end
end
