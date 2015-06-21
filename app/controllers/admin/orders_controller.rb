module Admin
  class OrdersController < BaseController
    def new
      @order_form = NewOrderForm.new(customer: customer)
    end

    def create
      @order_form = NewOrderForm.new(customer: customer,
                                  form_params: params[:admin_new_order_form])
      @create_order = CreateOrderService.new(user: current_user,
                                             form: @order_form).perform
      @edit_customer_view = Customers::EditView.new(customer)
    end

    def update
      order_form = ExistingOrderForm.new(order: order, form_params: params[:admin_existing_order_form])
      @update_order = UpdateOrderService.new(current_user: current_user,
                                             order: order,
                                             form: order_form).perform
      @order_view_model = Orders::EditView.new(order, order_form)
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
      @cancel_order = CancelOrderService.new(order: order,
                                             user: current_user).perform
      @edit_customer_view = Customers::EditView.new(customer)
    end

    private

    def order
      @order ||= customer.orders.find(params[:id])
    end

    def customer
      @customer ||= Customer.find(params[:customer_id])
    end
  end
end
