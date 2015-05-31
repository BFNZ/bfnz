module Admin
  class CancelOrder
    def initialize(order:, user:)
      @order = order
      @user = user
    end

    def perform
      cancel_order
      self
    end

    def success?
      @success
    end

    private

    def cancel_order
      CancelledOrderEvent.create!(cancelled_by: @user, customer_id: @order.customer_id, order_details: order_details)
      @success = @order.destroy
    end

    def order_details
      @order.attributes
    end
  end
end
