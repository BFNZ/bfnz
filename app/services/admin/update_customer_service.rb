module Admin
  class UpdateCustomerService
    def initialize(current_user, form)
      @user = current_user
      @form = form
      @customer = form.customer
      @success = false
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
      @customer.assign_attributes(
        first_name: @form.first_name,
        last_name: @form.last_name,
        updated_by: @user
      )
      @customer.save
    end
  end
end
