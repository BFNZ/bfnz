module Admin
  class CustomersController < BaseController
    def new
      @order_form = OrderForm.new(form_params: params[:admin_order_form])

    end

    def create
      @order_form = OrderForm.new(form_params: params[:admin_order_form])

      order_service = CreateOrderService.new(current_user, @order_form)
      if order_service.save
        redirect_to new_admin_customer_path, notice: "Order created successfully."
      else
        render :new
      end
    end

    def edit
      @customer_presenter = CustomerPresenter.new(customer)
      @customer_form = CustomerForm.new(customer: customer, form_params: params[:admin_customer_form])
    end

    def update
      @customer_form = CustomerForm.new(customer: customer, form_params: params[:admin_customer_form])
      @update_customer = UpdateCustomerService.new(current_user, @customer_form).perform
    end

    private

    def customer
      @customer ||= Customer.find(params[:id])
    end

  end
end
