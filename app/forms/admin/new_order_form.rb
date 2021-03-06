module Admin
  class NewOrderForm < BaseForm
    attribute :method_received, String
    attribute :method_of_discovery, String
    attribute :item_ids, Array[Integer]
    attribute :received_in_person, Virtus::Attribute::Boolean

    validate :contains_at_least_one_item

    attr_reader :customer

    def initialize(customer:, form_params: nil)
      @customer = customer
      super form_params
    end

    def item_ids=(item_ids)
      super item_ids.reject(&:blank?)
    end

    private

    def contains_at_least_one_item
      errors.add(:item_ids, :cant_be_empty) if item_ids.none?
    end
  end
end
