module Admin
  class MergeCustomerForm < BaseForm
    
    attr_accessor :duplicate_id

    validate :duplicate_exists
    validate :duplicate_is_not_the_original_record
    validate :duplicate_is_not_already_merged

    attr_reader :original

    def initialize(original:, duplicate_id:)
      @original = original
      super(duplicate_id: duplicate_id)
    end

    def duplicate
      @duplicate ||= Customer.find_by_id(duplicate_id)
    end

    def error_message
      errors.full_messages.join(", ")
    end

    private

    def duplicate_exists
      errors.add(:customer_id, "Could not find a customer with ID #{duplicate_id}") if duplicate.nil?
    end

    def duplicate_is_not_the_original_record
      errors.add(:customer_id, "Can't merge the same record into itself") if duplicate == original
    end

    def duplicate_is_not_already_merged
      errors.add(:customer_id, "#{duplicate.identifier} has already been merged into customer ##{duplicate.parent_id}") if duplicate.parent_id
    end
  end
end
