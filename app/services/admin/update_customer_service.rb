module Admin
  class UpdateCustomerService

    def initialize(current_user, form = {})
      @user = current_user
      @form = form
      @customer = form.customer
    end

    def perform
      @updated_customer_attributes = customer_attributes(@form).merge(updated_by: @user)
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
      @customer.update(@updated_customer_attributes)
    end

    def customer_attributes(form)
      {
        title: form.title,
        first_name: form.first_name,
        last_name: form.last_name,
        address: form.address,
        suburb: form.suburb,
        city_town: form.city_town,
        post_code: form.post_code,
        pxid: form.pxid,
        dpid: form.dpid,
        x: form.x,
        y: form.y,
        ta: form.ta,
        bad_address: form.bad_address,
        phone: form.phone,
        email: form.email,
        tertiary_student: form.tertiary_student,
        tertiary_institution: form.tertiary_institution,
        further_contact_requested: form.further_contact_requested.to_i,
        admin_notes: form.admin_notes
      }
    end

  end
end
