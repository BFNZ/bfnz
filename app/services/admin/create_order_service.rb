class Admin::CreateOrderService
  def initialize(current_user, form)
    @user = current_user
    @form = form
  end

  def save
    if @form.valid?
      customer.save!
      order.save!
    else
      false
    end
  end

  def order
    @order ||= customer.orders.build(@form.order_attributes.merge(:created_by => @user))
  end

  def customer
    @customer ||= Customer.new(@form.customer_attributes)
  end
end
