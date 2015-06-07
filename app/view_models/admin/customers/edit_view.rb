module Admin
  module Customers
    class EditView
      attr_reader :customer

      def initialize(customer)
        @customer = customer
      end

      def order_views
        customer.orders.order('created_at desc').map do |order|
          if order.shipped?
            Orders::ShowView.new(order)
          else
            Orders::EditView.new(order, ExistingOrderForm.new(item_ids: order.item_ids))
          end
        end
      end

      def merged_customer_views
        customer.merged_customers.map do |merged_customer|
          MergedView.new(merged_customer)
        end
      end

      def customer_id
        customer.identifier
      end

      private

      attr_reader :order_id

      class MergedView
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

        def method_received
          customer.method_received
        end

        def method_of_discovery
          customer.method_of_discovery
        end
      end
    end
  end
end
