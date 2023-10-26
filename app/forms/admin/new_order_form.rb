module Admin
  class NewOrderForm < BaseForm
    attr_accessor :method_received, :method_of_discovery, :item_ids, :received_in_person

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
