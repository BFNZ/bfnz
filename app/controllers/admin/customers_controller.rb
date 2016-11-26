module Admin
  class CustomersController < BaseController
    def new
      @new_customer_form = NewCustomerForm.new(params[:admin_new_customer_form])
    end

    def create
      @new_customer_form = NewCustomerForm.new(params[:admin_new_customer_form])
      if params[:commit] == "Search Duplicates"
        @duplicate_customers_by_name = get_duplicate_customers_by_name
        @duplicate_customers_by_address = get_duplicate_customers_by_address
        return render :new
      end

      create_customer = CreateCustomerService.new(user: current_user,
                                                  form: @new_customer_form).perform
      if create_customer.success?
        redirect_to new_admin_customer_path, notice: "Customer created successfully. Customer Id: #{view_context.link_to(create_customer.cust_id, edit_admin_customer_path(create_customer.cust_id))}"
      else
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

    def merge
      merge_form = MergeCustomerForm.new(original: customer, duplicate_id: params[:duplicate_id])
      @merge_customer = MergeCustomerService.new(user: current_user, form: merge_form).perform
      @edit_view_model = Customers::EditView.new(customer.reload)
    end

    private

    def customer
      @customer ||= Customer.find(params[:id])
    end

    def get_duplicate_customers_by_name
      return [] if @new_customer_form.first_name.blank?
      return [] if @new_customer_form.last_name.blank?

      Customer.where(
        first_name: @new_customer_form.first_name,
        last_name: @new_customer_form.last_name
      )
    end

    def get_duplicate_customers_by_address
      return [] if @new_customer_form.pxid.blank?

      puts "search by address #{@new_customer_form.pxid}"
      Customer.where(
        pxid: @new_customer_form.pxid
      )
    end

  end
end
