module Admin
  class OrdersPresenter
    def initialize(orders, current_page)
      @orders = orders
      @current_page = current_page
    end

    def orders_for_current_page
      @orders_for_current_page ||= orders.page(@current_page)
    end

    def order_presenters(&block)
      orders_for_current_page.map { |order| yield OrderPresenter.new(order) }
    end

    private

    attr_reader :orders

  end
end
