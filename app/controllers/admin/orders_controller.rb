require 'csv'

class Admin::OrdersController < Admin::BaseController
  def index
    @order_search_form = Admin::OrderSearchForm.new(params[:admin_order_search_form])
    orders = @order_search_form.filtered_orders

    params[:format] = 'csv' if params[:csv]
    respond_to do |format|
      format.html do
        @orders = orders.page params[:page]
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

  def mark_duplicate
    order_service = Admin::UpdateOrderDuplicateStatus.new(params: params, duplicate: true)
    order_service.perform

    flash[:alert] = "<a href='#{edit_admin_order_path(params[:id])}'>Order ##{params[:id]}</a> has been marked as a duplicate and has been removed from the list of labels to download."
    redirect_to admin_labels_path
  end

  def unmark_duplicate
    order_service = Admin::UpdateOrderDuplicateStatus.new(params: params, duplicate: false)
    order_service.perform

    redirect_to case params[:return_to]
                when 'labels'
                  admin_labels_path
                when 'edit'
                  flash[:success] = "This order has been unmarked as a duplicate and can be shipped."
                  edit_admin_order_path(params[:id])
                else
                  admin_orders_path
                end
  end
end
