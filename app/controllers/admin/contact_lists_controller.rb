require 'csv'
module Admin
  class ContactListsController < BaseController
    def index
      @view_model = ContactLists::IndexView.new(coordinator_id: params[:coordinator_id])
    end

    def create
      create_contact_list = CreateContactListService.new(district_id: params[:district_id])
      create_contact_list.perform

      redirect_to admin_contact_list_path(create_contact_list.contact_list, format: 'csv')
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
