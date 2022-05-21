module Admin
  module Customers
    class MergeView
      def initialize(original:, duplicate:)
        @original = original
        @duplicate = duplicate
      end

      def duplicate_identifier
        duplicate.identifier
      end

      def original_identifier
        original.identifier
      end

      def duplicate_id
        duplicate.id
      end

      def original_id
        original.id
      end

      def show_view_model
        ShowView.new(duplicate)
      end

      def order_view_models
        duplicate.orders.map do |order|
          Orders::ShowView.new(order)
        end
      end

      private

      attr_reader :duplicate, :original

    end
  end
end
