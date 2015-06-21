module Admin
  module Customers
    class MergeView
      attr_reader :customer

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

      def able_to_merge?
       duplicate.present? && !same_customer_record?
      end

      def show_view_model
        ShowView.new(duplicate)
      end

      def error_message
        if duplicate.nil?
          "Could not find a customer with that ID"
        elsif same_customer_record?
          "Can't merge the same record into itself"
        end
      end

      def order_view_models
        duplicate.orders.map do |order|
          Orders::ShowView.new(order)
        end
      end

      private

      attr_reader :duplicate, :original

      def same_customer_record?
        duplicate == original
      end
    end
  end
end
