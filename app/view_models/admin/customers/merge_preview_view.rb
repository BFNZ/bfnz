module Admin
  module Customers
    class MergePreviewView
      attr_reader :customer

      def initialize(customer)
        @customer = customer
      end

      def found_customer?
        customer.present?
      end

      def customer_id
        customer.identifier
      end

      def message
        "Could not find a customer with that ID" unless found_customer?
      end

      private

      attr_reader :customer

    end
  end
end
