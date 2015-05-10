module Admin
  class CustomersController < BaseController
    def edit
      @customer_presenter = CustomerPresenter.new(customer)
      @customer_form = CustomerForm.new(customer: customer, form_params: params[:admin_customer])
    end

    def update
    end

    private

    def customer
      @customer ||= Customer.find(params[:id])
    end

  end
end
