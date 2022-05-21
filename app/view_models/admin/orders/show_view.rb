module Admin
  module Orders
    class ShowView
      def initialize(order)
        @order = order
      end

      def partial
        'admin/customers/order'
      end

      def order_identifier
        order.identifier
      end

      def date_ordered
        order.created_at.to_date.to_s(:display)
      end

      def date_shipped
        if order.shipped?
          order.shipped_at.to_date.to_s(:display)
        else
          "Not yet shipped"
        end
      end

      def titles_ordered
        order.items.map(&:title)
      end

      private

      attr_reader :order

    end
  end
end
