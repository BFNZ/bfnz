class Admin::UpdateOrderService

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

  private

  def save_order
    @success = @order.update(@form.attributes.merge(:updated_by => @user))
  end
end
