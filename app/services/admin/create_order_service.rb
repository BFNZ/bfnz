module Admin
  class CreateOrderService
    def initialize(user:, form:)
      @user = user
      @form = form
      @customer = form.customer
    end

    def perform
      if @form.valid?
        @success = save_order && create_shipment
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

    def create_shipment
      if order.received_in_person?
        Shipment.create_for_orders(Order.where(id: order.id))
      end
      true
    end
  end
end
