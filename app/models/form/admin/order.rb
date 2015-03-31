class Form::Admin::Order < Form::Order
  attribute :method_received, String
  attribute :method_of_discovery, String

  attribute :admin_notes, String

  attr_reader :order

  delegate :id, :persisted?, :duplicate?, to: :order

  def initialize(order:, form_params: nil)
    @order = order
    super form_params || fetch_attrs_from_models
  end

  def order_attr_keys
    super + %w{method_received method_of_discovery}
  end

  def customer_attr_keys
    super + %w{admin_notes}
  end

  def path_for_order
    order.persisted? ? url_helper.admin_order_path(order) : url_helper.admin_orders_path
  end

  private

  def fetch_attrs_from_models
    if customer
      order.attributes.slice(*order_attr_keys).
        merge('method_of_discovery' => order.method_of_discovery,
              'method_received' => order.method_received,
              'item_ids' => order.item_ids).
        merge(customer.attributes.slice(*customer_attr_keys))
    else
      {}
    end
  end

  def customer
    order.customer
  end

  def url_helper
    Rails.application.routes.url_helpers
  end
end
