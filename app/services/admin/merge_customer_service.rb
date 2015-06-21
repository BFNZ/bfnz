module Admin
  class MergeCustomerService

    def initialize(user:, original:, duplicate:)
      @user = user
      @original = original
      @duplicate = duplicate
    end

    def perform
      if able_to_merge?
        @success = merge_customer
      end
      self
    end

    def success?
      @success
    end

    def message
      success? ? "Customer merged successfully" : "Could not merge customer"
    end

    private

    def able_to_merge?
      @duplicate.present? && @duplicate != @original
    end

    def merge_customer
      Customer.transaction do
        @original.orders << @duplicate.orders
        @duplicate.update!(parent_id: @original.id, updated_by_id: @user.id)
        @original.update!(updated_by_id: @user.id)
      end
      true
    rescue ActiveRecord::RecordInvalid
      false
    end
  end
end
