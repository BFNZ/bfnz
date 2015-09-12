module Admin
  class CreateCustomerService
    def initialize(user:, form:)
      @user = user
      @form = form
    end

    def perform
      if @form.valid?
        @success = (save_customer && save_order && create_shipment)
      end
      self
    end

    def success?
      @success
    end

    private

    attr_reader :form, :user

    def order
      @order ||= customer.orders.build(form.order_attributes.merge(:created_by => user))
    end

    def customer
      @customer ||= Customer.new(form.customer_attributes.merge(:created_by => user))
    end

    def save_customer
      customer.save
    end

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
