require 'csv'

class Admin::ShipmentsController < Admin::BaseController

  def index
    @shipments = Shipment.order('id desc').page params[:page]
  end

  def show
    shipment = Shipment.find(params[:id])
    respond_to do |format|
      format.csv do
        @label_presenter = Admin::LabelPresenter.new(shipment)
        headers['Content-Disposition'] = "attachment; filename=\"#{shipment.filename}.csv\""
        headers['Content-Type'] = 'text/csv'
      end
    end
  end
end
