module Admin
  module Orders
    class EditView
      def initialize(order, form)
        @order = order
        @form = form
      end

      def partial
        'admin/customers/editable_order'
      end

      def form
        @form
      end

      def order_identifier
        "##{customer_id}.#{order_id}"
      end

      def form_id
        "form_#{order_id}"
      end

      def date_ordered
        order.created_at.to_date.to_fs(:display)
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
