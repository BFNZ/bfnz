require 'csv'

class Admin::ShipmentsController < Admin::BaseController

  def index
    @shipments = Shipment.order('id desc')
  end

  def show
    shipment = Shipment.find(params[:id])
    respond_to do |format|
      format.csv do
        @label_presenters = Admin::LabelPresenter.for_shipment(shipment)
        headers['Content-Disposition'] = "attachment; filename=\"#{shipment.filename}\""
        headers['Content-Type'] = 'text/csv'
      end
    end
  end
end
