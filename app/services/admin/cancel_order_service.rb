module Admin
  class CancelOrderService
    def initialize(order:, user:)
      @order = order
      @user = user
    end

    def perform
      @success = cancel_order
      self
    end

    def success?
      @success
    end

    def message
      success? ? "Order cancelled" : "Sorry, that didn't work"
    end

    private

    def cancel_order
      CancelledOrderEvent.create!(cancelled_by_id: @user.id, customer_id: @order.customer_id, order_details: order_details)
      @order.destroy
      @order.destroyed?
    end

    def order_details
      @order.attributes.merge(item_ids: @order.item_ids)
    end
  end
end
