class Admin::LabelsController < Admin::BaseController

  def index
    @orders = Order.ready_to_ship.order(:id)
    @potential_duplicates = []
    Order.unshipped_potential_duplicates do |suspect_order|
      @potential_duplicates << Admin::DuplicateOrderPresenter.new(suspect_order)
    end

    respond_to do |format|
      format.html
      format.csv do
        return redirect_to admin_labels_path if @orders.empty?

        shipment = Shipment.create_for_orders(@orders)
        @label_presenters = Admin::LabelPresenter.for_shipment(shipment)
        headers['Content-Disposition'] = "attachment; filename=\"#{shipment.filename}\""
        headers['Content-Type'] = 'text/csv'

        render 'admin/shipments/show'
      end
    end
  end
end
