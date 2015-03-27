class Form::Admin::Order
  include Virtus.model
  include ActiveModel::Model

  attribute :title, String
  attribute :first_name, String
  attribute :last_name, String

  attribute :address, String
  attribute :suburb, String
  attribute :city_town, String
  attribute :post_code, String
  attribute :pxid, String
  attribute :ta, String

  attribute :phone, String
  attribute :email, String

  attribute :method_received, String
  attribute :method_of_discovery, String

  attribute :tertiary_student, Virtus::Attribute::Boolean
  attribute :tertiary_institution, String

  attribute :admin_notes, String

  attribute :item_ids, Array[Integer]

  attribute :further_contact_requested, Virtus::Attribute::Boolean

  validates :title, :first_name, :last_name, :address, presence: true
  validate :contains_at_least_one_item

  attr_reader :order

  delegate :id, :persisted?, :duplicate?, to: :order

  ORDER_ATTRIBUTES = %w{method_received method_of_discovery item_ids}
  CUSTOMER_ATTRIBUTES = %w{title first_name last_name address suburb city_town post_code pxid ta phone email tertiary_student tertiary_institution further_contact_requested admin_notes}

  def initialize(order:, form_params: nil)
    @order = order
    super form_params || fetch_attrs_from_models
  end

  def path_for_order
    order.persisted? ? url_helper.admin_order_path(order) : url_helper.admin_orders_path
  end

  def order_attributes
    attributes.stringify_keys.slice(*ORDER_ATTRIBUTES)
  end

  def customer_attributes
    attributes.stringify_keys.slice(*CUSTOMER_ATTRIBUTES)
  end

  private

  def fetch_attrs_from_models
    if customer
      order.attributes.slice(*ORDER_ATTRIBUTES).merge('method_of_discovery' => order.method_of_discovery, 'method_received' => order.method_received, 'item_ids' => order.item_ids).
        merge(customer.attributes.slice(*CUSTOMER_ATTRIBUTES))
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

  def contains_at_least_one_item
    errors.add(:item_ids, "You must select at least one item") if item_ids.none?
  end
end
