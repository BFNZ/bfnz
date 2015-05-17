module Admin
  class CustomerPresenter
    attr_reader :customer

    def initialize(customer)
      @customer = customer
    end

    def each_order(&block)
      customer.orders.order('created_at desc').each do |order|
        yield OrderPresenter.new(order)
      end
    end

    def customer_id
      "##{customer.id}"
    end

    private

    attr_reader :order_id

    class OrderPresenter
      def initialize(order)
        @order = order
      end

      def order_identifier
        "##{customer_id}.#{order_id}"
      end

      def date_ordered
        order.created_at.to_date.to_s(:display)
      end

      def date_shipped
        order.shipped_at.to_date.to_s(:display)
      end

      def order_shipped?
        order.shipped?
      end

      def titles_ordered
        order.items.map(&:title)
      end

      def item_ids
        order.item_ids
      end

      def customer_id
        order.customer_id
      end

      def order_id
        order.id
      end

      private

      attr_reader :order

    end
  end
end
