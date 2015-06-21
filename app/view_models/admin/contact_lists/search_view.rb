module Admin
  module ContactLists
    class SearchView
      attr_reader :selected_ta, :contact_search, :contacts, :coordinator

      def initialize(contact_search:, page: nil)
        @contact_search = contact_search
        @selected_ta = @contact_search.selected_ta

        if @selected_ta
          @contacts = @contact_search.contactable_customers.page(page)
          @coordinator = @selected_ta.coordinator
        end
      end

      def contact_lists
        ContactList.for_ta(selected_ta)
      end

      def contact_list
        ContactList.create_for_ta(selected_ta, contacts)
      end

      # TODO refactor this into a view model
      def contact_presenters
        contacts.map do |contact|
          Admin::ContactPresenter.new(contact)
        end
      end

      def current_coordinator
        if coordinator
          "#{coordinator.name} is the coordinator for this district"
        else
          "Warning! No coordinator has been assigned for this district"
        end
      end

      def error
        case
        when !selected_ta
          "Please select a district first"
        when contacts.none?
          "There are no contacts to download for this district"
        when !coordinator
          "You need to assign a coordinator to this district first"
        end
      end

      private

      attr_reader :coordinator
    end
  end
end
