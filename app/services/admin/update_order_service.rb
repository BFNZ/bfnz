module Admin
  class UpdateOrderService

    def initialize(current_user:, order:, form:)
      @user = current_user
      @order = order
      @form = form
    end

    def perform
      if @form.valid?
        @success = save_order
      end
      self
    end

    def success?
      @success
    end

    def message
      success? ? "Order #{@order.identifier} updated" : "Please fix the errors below"
    end

    private

    def save_order
      @order.assign_attributes(
        method_received: @form.method_received,
        method_of_discovery: @form.method_of_discovery,
        item_ids: @form.item_ids,
        updated_by: @user
      )
      @order.save
    end
  end
end
