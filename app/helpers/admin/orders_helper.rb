module Admin::OrdersHelper
  def method_of_discovery_options
    Order.method_of_discoveries.map { |k,v| [k.humanize,k] }
  end

  def method_received_options
    Order.method_receiveds.map { |k,v| [k.humanize,k] }
  end

  def admin_order_form_save_button
    @order.new_record? ? 'Save and add another' : 'Update'
  end
end
