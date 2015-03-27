class Admin::UpdateOrderService

  def initialize(current_user, form)
    @user = current_user
    @form = form
    @order = form.order
    @customer = @order.customer
  end

  def save
    save_customer && save_order
  end

  private

  def save_customer
    @customer.update(@form.customer_attributes.merge(:updated_by => @user))
  end

  def save_order
    @order.update(@form.order_attributes.merge(:updated_by => @user))
  end
end
