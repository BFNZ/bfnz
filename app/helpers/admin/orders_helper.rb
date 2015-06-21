module Admin::OrdersHelper
  def method_of_discovery_options
    Order.method_of_discoveries.map { |k,v| [k.humanize,k] }
  end

  def method_received_options
    Order.method_receiveds.map { |k,v| [k.humanize,k] }
  end

  def mark_duplicate_button(id)
    link_to 'Mark as Duplicate', mark_duplicate_admin_order_path(id), class: 'btn btn-danger', method: :put
  end

  def unmark_duplicate_button(id:, return_to: :labels)
    link_to 'Unmark as Duplicate', unmark_duplicate_admin_order_path(id, return_to: return_to), class: 'btn btn-success', method: :put
  end
end
