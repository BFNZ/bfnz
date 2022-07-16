require 'csv'

module Admin
  class SearchController < BaseController
    before_action :permit_params

    def index
      @order_search = OrderSearchForm.new(params[:admin_order_search_form])
      orders = @order_search.filtered_orders

      params[:format] = 'csv' if params[:csv]
      respond_to do |format|
        format.html do
          @orders_presenter = OrdersPresenter.new(orders, params[:page])
        end
        format.csv do
          @order_view_models = orders.map { |order| Admin::Orders::CsvView.new(order) }
          headers['Content-Disposition'] = "attachment; filename=\"orders.csv\""
          headers['Content-Type'] = 'text/csv'
        end
      end
    end
  end
end
