require 'csv'
module Admin
  class ContactListsController < BaseController
    def index
      @contact_search = Form::Admin::ContactListSearch.new(params[:form_admin_contact_list_search])

      @search_view_model = ContactLists::SearchView.new(contact_search: @contact_search)

      respond_to do |format|
        format.html
        format.csv do
          return redirect_to admin_contact_lists_path(form_admin_contact_list_search: params[:form_admin_contact_list_search]), :alert => @search_view_model.error if @search_view_model.error

          @csv_view = Admin::ContactLists::CsvView.new(@search_view_model.contact_list)
          headers['Content-Disposition'] = "attachment; filename=\"#{@csv_view.filename}\""
          headers['Content-Type'] = 'text/csv'

          render 'admin/contact_lists/show'
        end
      end
    end

    def show
      contact_list = ContactList.find(params[:id])
      respond_to do |format|
        format.csv do
          @csv_view = ContactLists::CsvView.new(contact_list)
          headers['Content-Disposition'] = "attachment; filename=\"#{@csv_view.filename}.csv\""
          headers['Content-Type'] = 'text/csv'
        end
      end
    end
  end
end
