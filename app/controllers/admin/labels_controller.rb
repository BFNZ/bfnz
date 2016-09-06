module Admin
  class LabelsController < BaseController

    def index
      @orders = Order.ready_to_ship.order(:id)
      @index_view = Labels::IndexView.new(@orders)

      respond_to do |format|
        format.html
        format.csv do
          return redirect_to admin_labels_path if @orders.empty?

          shipment = Shipment.create_for_orders(@orders)
          @label_presenter = Admin::LabelPresenter.new(shipment)
          headers['Content-Disposition'] = "attachment; filename=\"#{shipment.filename}.csv\""
          headers['Content-Type'] = 'text/csv'

          render 'admin/shipments/show'
        end
      end
    end
  end
end
