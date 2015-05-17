require 'csv'
module Admin
  class OrdersController < BaseController
    before_filter :setup_order_form, only: [:edit, :update]

    def index
      @order_search = Form::Admin::OrderSearch.new(params[:form_admin_order_search])
      orders = @order_search.filtered_orders

      params[:format] = 'csv' if params[:csv]
      respond_to do |format|
        format.html do
          @orders_presenter = OrdersPresenter.new(orders, params[:page])
        end
        format.csv do
          @order_presenters = orders.map { |order| OrderCsvPresenter.new(order) }
          headers['Content-Disposition'] = "attachment; filename=\"orders\""
          headers['Content-Type'] = 'text/csv'
        end
      end
    end

    def new
    end

    def create
    end

    def edit
    end

    def update
      order_service = UpdateOrderService.new(current_user, @order_form)
      if order_service.save
        redirect_to admin_orders_path, notice: "Order updated successfully."
      else
        render :edit
      end
    end

    def mark_duplicate
      order_service = UpdateOrderDuplicateStatus.new(params: params, duplicate: true)
      order_service.perform

      flash[:alert] = "<a href='#{edit_admin_order_path(params[:id])}'>Order ##{params[:id]}</a> has been marked as a duplicate and has been removed from the list of labels to download."
      redirect_to admin_labels_path
    end

    def unmark_duplicate
      order_service = UpdateOrderDuplicateStatus.new(params: params, duplicate: false)
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

    def find_order_to_compare
      other_order_id = params[:other_order_id]

      #check they belong to different customers
      redirect_to compare_admin_order_path(@order.id, other_order_id)
    end

    def destroy
      cancel_order = CancelOrder.new(order: order, user: current_user)
      cancel_order.perform

      redirect_to edit_admin_customer_path(customer)
    end

    private

    def setup_order_form
      @order_form = Admin::OrderForm.new(order: order,
                                         form_params: params[:form_admin_order])
    end

    def order
      @order ||= customer.orders.find(params[:id])
    end

    def customer
      @customer ||= Customer.find(params[:customer_id])
    end
  end
end
