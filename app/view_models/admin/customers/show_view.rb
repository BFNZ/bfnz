module Admin
  module Customers
    class ShowView
      def initialize(customer)
        @customer = customer
      end

      def customer_identifier
        customer.identifier
      end

      def name
        [customer.title, customer.first_name, customer.last_name].join(" ")
      end

      def address
        [customer.address, customer.suburb, "#{customer.city_town} #{customer.post_code}"].join("<br>").html_safe
      end

      def phone
        customer.phone
      end

      def email
        customer.email
      end

      private

      attr_reader :customer
    end
  end
end
