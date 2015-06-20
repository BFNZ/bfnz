module Admin
  class UpdateOrderService

    def initialize(current_user:, order:, form:)
      @user = current_user
      @order = order
      @form = form
    end

    def perform
      if @form.valid?
        save_order
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
      @success = @order.update(@form.attributes.merge(:updated_by => @user))
    end
  end
end
