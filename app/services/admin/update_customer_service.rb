class Admin::UpdateCustomerService

  def initialize(current_user, form)
    @user = current_user
    @form = form
    @customer = form.customer
  end

  def perform
    save_customer
    self
  end

  def success?
    @success
  end

  private

  def save_customer
    @success = @customer.update(@form.attributes.merge(:updated_by => @user))
  end
end
