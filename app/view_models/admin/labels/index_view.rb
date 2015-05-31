module Admin
  module Labels
    class IndexView
      def initialize(orders)
        @orders = orders
      end

      def each_order
        @orders.each do |order|
          yield OrderView.new(order)
        end
      end

      def label_count
        @orders.count
      end

      def any_labels_to_download?
        @orders.any?
      end

      class OrderView
        def initialize(order)
          @order = order
        end

        delegate :potential_duplicates, to: :order
        delegate :full_name, :address, :email, :phone, to: :customer

        def order_id
          order.id
        end

        def created
          "#{order.created_at.to_s(:display)} by #{created_by}"
        end

        def items
          order.item_codes
        end

        def marked_as_duplicate?
          order.duplicate?
        end

        def customer_id
          customer.id
        end

        private

        attr_reader :order

        def customer
          order.customer
        end

        def created_by
          order.created_by ? order.created_by.name : order.ip_address
        end
      end
    end
  end
end
