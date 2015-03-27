require 'csv'

class Admin::ContactListsController < Admin::BaseController
  def index
    @contact_search = Form::Admin::ContactListSearch.new(params[:form_admin_contact_list_search])

    if @contact_search.selected_ta
      @contacts = @contact_search.contactable_customers.page params[:page]
      @coordinator = @contact_search.selected_ta.coordinator
      @contact_lists = ContactList.for_ta(@contact_search.selected_ta)
    end

    respond_to do |format|
      format.html
      format.csv do
        error = case
                when @contact_search.selected_ta.nil?
                  "Please select a district first"
                when @contacts.none?
                  "There are no contacts to download for this district"
                when @coordinator.nil?
                  "You need to assign a coordinator to this district first"
                end

        return redirect_to admin_contact_lists_path(form_admin_contact_list_search: params[:form_admin_contact_list_search]), :alert => error if error

        contact_list = ContactList.create_for_ta(@contact_search.selected_ta, @contacts)
        @contact_list_presenter = Admin::ContactListCsvPresenter.new(contact_list)
        headers['Content-Disposition'] = "attachment; filename=\"#{contact_list.filename}\""
        headers['Content-Type'] = 'text/csv'

        render 'admin/contact_lists/show'
      end
    end
  end

  def show
    contact_list = ContactList.find(params[:id])
    respond_to do |format|
      format.csv do
        @presenter = Admin::ContactListCsvPresenter.new(contact_list)
        headers['Content-Disposition'] = "attachment; filename=\"#{contact_list.filename}.csv\""
        headers['Content-Type'] = 'text/csv'
      end
    end
  end

end
