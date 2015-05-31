module Admin
  class ExistingOrderForm < BaseForm
    attribute :item_ids, Array[Integer]

    validate :contains_at_least_one_item

    def item_ids=(item_ids)
      super item_ids.reject(&:blank?)
    end

    private

    def contains_at_least_one_item
      errors.add(:item_ids, :cant_be_empty) if item_ids.none?
    end
  end
end
