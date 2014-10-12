class Admin::OrdersController < Admin::BaseController
  def index
    @order_search_form = Admin::OrderSearchForm.new(params[:admin_order_search_form])
    @order_presenters = @order_search_form.filtered_orders.map { |order| Admin::OrderPresenter.new(order) }
  end

  def new
    @order = Order.new
  end

  def create
    order_service = CreateOrderService.new(request, params)
    if order_service.save
      redirect_to admin_orders_path, notice: "Order created."
    else
      @order = order_service.order
      render :new
    end
  end

  def edit
    @order = Order.find(params[:id])
  end

  def update
    order_service = UpdateOrderService.new(request, params)
    if order_service.save
      redirect_to admin_orders_path, notice: "Order updated."
    else
      @order = order_service.order
      render :edit
    end
  end
end
