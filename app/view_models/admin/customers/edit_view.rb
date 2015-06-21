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
            Orders::EditView.new(order, ExistingOrderForm.new(order: order))
          end
        end
      end

      def merged_customer_views
        customer.merged_customers.map do |merged_customer|
          ShowView.new(merged_customer)
        end
      end

      def customer_identifier
        customer.identifier
      end

      def customer_id
        customer.id
      end

      private

      attr_reader :order_id

    end
  end
end
