class OrdersController < ApplicationController
  def new
    @order = Order.new
    @districts = District.all
  end

  def create
    redirect_to new_order_path
  end
end
