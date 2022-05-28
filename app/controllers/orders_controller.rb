class OrdersController < ApplicationController
  before_action :permit_params, :setup_order_form

  def new
  end

  def create
    order_service = CreateOrderService.new(request, @order_form)
    if order_service.save
      redirect_to root_path, notice: "Thanks, your order will be shipped as soon as possible"
    else
      render :new
    end
  end

  def create_table_order
    order_service = CreateOrderService.new(request, @order_form, table_id)
    if order_service.save
      redirect_to show_table_path, notice: "Form submitted successfully. Have a great day!" # better wording for the notice?
    else
      flash[:error] = @order_form.errors.full_messages.join("<br>")
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def setup_order_form
    preloaded_settings = params[:action] == "create_table_order" ? {confirm_personal_order: '1', item_ids: [Item.find_by(code: "R").id]} : {}
    @order_form ||= params[:customer_and_order_form] ?
      CustomerAndOrderForm.new(params[:customer_and_order_form].merge(preloaded_settings)) :
      CustomerAndOrderForm.new({})
  end

  def table_id
    params[:table_id]
  end
end
