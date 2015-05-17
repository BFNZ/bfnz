module Admin
  class CancelOrder
    def initialize(order:, user:)
      @order = order
      @user = user
    end

    def perform
      CancelledOrderEvent.create!(cancelled_by: @user, customer_id: @order.customer_id, order_details: order_details)
      @order.destroy
    end

    private

    def order_details
      @order.attributes
    end
  end
end
