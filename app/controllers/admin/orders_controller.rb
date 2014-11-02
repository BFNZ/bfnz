require 'csv'

class Admin::OrdersController < Admin::BaseController
  def index
    @order_search_form = Admin::OrderSearchForm.new(params[:admin_order_search_form])
    orders = @order_search_form.filtered_orders

    params[:format] = 'csv' if params[:csv]
    respond_to do |format|
      format.html do
        @order_presenters = orders.map { |order| Admin::OrderPresenter.new(order) }
      end
      format.csv do
        @order_presenters = orders.map { |order| Admin::OrderCsvPresenter.new(order) }
        headers['Content-Disposition'] = "attachment; filename=\"orders\""
        headers['Content-Type'] = 'text/csv'
      end
    end
  end

  def new
    @order = Order.new
  end

  def create
    order_service = Admin::CreateOrderService.new(current_user, params)
    if order_service.save
      redirect_to new_admin_order_path, notice: "Order created successfully."
    else
      @order = order_service.order
      render :new
    end
  end

  def edit
    @order = Order.find(params[:id])
  end

  def update
    order_service = Admin::UpdateOrderService.new(current_user, params)
    if order_service.save
      redirect_to admin_orders_path, notice: "Order updated successfully."
    else
      @order = order_service.order
      render :edit
    end
  end
end
