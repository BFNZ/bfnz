module Admin
  class CustomerPresenter
    attr_reader :customer

    def initialize(customer)
      @customer = customer
    end

    def each_order(&block)
      customer.orders.order('created_at desc').each do |order|
        view = if order.shipped?
                 Admin::Orders::ShowView.new(order)
               else
                 Admin::Orders::EditView.new(order, Admin::ExistingOrderForm.new(item_ids: order.item_ids))
               end
        yield view
      end
    end

    def customer_id
      "##{customer.id}"
    end

    private

    attr_reader :order_id

  end
end
