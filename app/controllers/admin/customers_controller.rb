module Admin
  class CustomersController < BaseController
    def new
      @new_customer_form = NewCustomerForm.new(params[:admin_new_customer_form])
    end

    def create
      @new_customer_form = NewCustomerForm.new(params[:admin_new_customer_form])

      create_customer = CreateCustomerService.new(user: current_user,
                                                  form: @new_customer_form).perform
      if create_customer.success?
        redirect_to new_admin_customer_path, notice: "Customer created successfully. Customer Id: #{view_context.link_to(create_customer.cust_id, edit_admin_customer_path(create_customer.cust_id))}"
      else
        @duplicates_by_name = duplicates_by_name(
          @new_customer_form.first_name,
          @new_customer_form.last_name
        )
        @duplicates_by_address = duplicates_by_address(
          @new_customer_form.pxid
        )
        render :new
      end
    end

    def edit
      @edit_view_model = Customers::EditView.new(customer)
      @customer_form = ExistingCustomerForm.new(customer: customer, form_params: params[:admin_existing_customer_form])
    end

    def update
      @customer_form = ExistingCustomerForm.new(customer: customer, form_params: params[:admin_existing_customer_form])
      @update_customer = UpdateCustomerService.new(current_user, @customer_form).perform
    end

    def find_duplicate
      @merge_form = MergeCustomerForm.new(original: customer, duplicate_id: params[:customer_id])
      @merge_view = Customers::MergeView.new(original: @merge_form.original, duplicate: @merge_form.duplicate)
    end

    def find_duplicate_by_name_or_address
      @duplicates_by_name = duplicates_by_name(
        params[:first_name], params[:last_name]
      )
      @duplicates_by_address = duplicates_by_address(
        params[:pxid]
      )
    end

    def merge
      merge_form = MergeCustomerForm.new(original: customer, duplicate_id: params[:duplicate_id])
      @merge_customer = MergeCustomerService.new(user: current_user, form: merge_form).perform
      @edit_view_model = Customers::EditView.new(customer.reload)
    end

    private

    def customer
      @customer ||= Customer.find(params[:id])
    end

    def duplicates_by_name first_name, last_name
      return [] if first_name.blank?
      return [] if last_name.blank?

      Customer.where(first_name: first_name, last_name: last_name)
    end

    def duplicates_by_address pxid
      return [] if pxid.blank?

      Customer.where(pxid: pxid)
    end

  end
end
