module Admin
  class CreateOrderService
    def initialize(user:, form:)
      @user = user
      @form = form
      @customer = form.customer
    end

    def perform
      if @form.valid?
        @success = save_order
      end
      self
    end

    def order
      @order ||= customer.orders.build(form.attributes.merge(:created_by => user))
    end

    def success?
      @success
    end

    def message
      success? ? "Order created successfully" : "Please fix the errors below"
    end

    private

    attr_reader :customer, :form, :user

    def save_order
      order.save
    end
  end
end
