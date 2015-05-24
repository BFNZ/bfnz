class Admin::CreateOrderService
  def initialize(user:, form:)
    @user = user
    @form = form
    @customer = form.customer
  end

  def perform
    if @form.valid?
      save_order
    end
    self
  end

  def order
    @order ||= customer.orders.build(form.attributes.merge(:created_by => user))
  end

  def success?
    @success
  end

  private

  attr_reader :customer, :form, :user

  def save_order
    @success = order.save
  end
end
