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
