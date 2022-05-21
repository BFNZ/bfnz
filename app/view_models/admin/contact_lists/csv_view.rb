module Admin
  module ContactLists
    class CsvView

      def initialize(contact_list)
        @contact_list = contact_list
      end

      def coordinator_name
        coordinator.name
      end

      def coordinator_email
        coordinator.email
      end

      def contacts
        contact_list.customers.map { |customer| Admin::ContactLists::ContactView.new(customer) }
      end

      def filename
        contact_list.filename
      end

      private

      attr_reader :contact_list

      def territorial_authority
        contact_list.territorial_authority
      end

      def coordinator
        territorial_authority.coordinator
      end
    end
  end
end
