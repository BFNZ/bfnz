module Admin
  class MergeCustomerService

    def initialize(user:, form:)
      @user = user
      @form = form
      @original = form.original
      @duplicate = form.duplicate
    end

    def perform
      if form.valid?
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

    attr_reader :form

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
