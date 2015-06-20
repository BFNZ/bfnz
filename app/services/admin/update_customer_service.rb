module Admin
  class UpdateCustomerService

    def initialize(current_user, form)
      @user = current_user
      @form = form
      @customer = form.customer
    end

    def perform
      if @form.valid?
        @success = save_customer
      end
      self
    end

    def success?
      @success
    end

    def message
      success? ? "Customer details updated successfully" : "Please fix the errors below"
    end

    private

    def save_customer
      @customer.update(@form.attributes.merge(:updated_by => @user))
    end
  end
end
