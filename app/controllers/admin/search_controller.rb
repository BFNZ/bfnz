require 'csv'

module Admin
  class SearchController < BaseController
    def index
      @order_search = OrderSearchForm.new(params[:admin_order_search_form])
      orders = @order_search.filtered_orders

      params[:format] = 'csv' if params[:csv]
      respond_to do |format|
        format.html do
          @orders_presenter = OrdersPresenter.new(orders, params[:page])
        end
        format.csv do
          @order_presenters = orders.map { |order| OrderCsvPresenter.new(order) }
          headers['Content-Disposition'] = "attachment; filename=\"orders\""
          headers['Content-Type'] = 'text/csv'
        end
      end
    end
  end
end
