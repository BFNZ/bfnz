module Admin
  class CreateOrderService
    def initialize(user:, form:)
      @user = user
      @form = form
      @customer = form.customer
      @success = false
    end

    def perform
      if @form.valid?
        @order = build_order
        @success = save_order && create_shipment
      end
      self
    end

    def order
      @order
    end

    def success?
      @success
    end

    def message
      success? ? "Order created successfully" : "Please fix the errors below"
    end

    private

    attr_reader :customer, :form, :user

    def build_order
      order = customer.orders.build
      order.attributes = {
        method_received: form.method_received,
        method_of_discovery: form.method_of_discovery,
        item_ids: form.item_ids,
        received_in_person: form.received_in_person
      }
      order.created_by = user
      order
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