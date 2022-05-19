module Admin
  class ExistingOrderForm < BaseForm
    attribute :item_ids, Array[Integer]
    attribute :method_received, String
    attribute :method_of_discovery, String

    validate :contains_at_least_one_item
    validates :method_received, :method_of_discovery, presence: true

    def initialize(order: , form_params: nil)
      @order = order
      super(form_params || order_attributes)
    end

    def item_ids=(item_ids)
      super item_ids.reject(&:blank?)
    end

    private

    attr_reader :order

    def order_attributes
      {
        item_ids: order.item_ids,
        method_received: order.method_received,
        method_of_discovery: order.method_of_discovery
      }
    end

    def contains_at_least_one_item
      errors.add(:item_ids, :cant_be_empty) if item_ids.none?
    end
  end
end
