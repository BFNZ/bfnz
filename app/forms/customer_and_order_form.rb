class CustomerAndOrderForm < BaseForm
  attribute :title, String
  attribute :first_name, String
  attribute :last_name, String

  attribute :address, String
  attribute :suburb, String
  attribute :city_town, String
  attribute :post_code, String
  attribute :dpid, String
  attribute :x, Decimal
  attribute :y, Decimal
  attribute :pxid, String

  attribute :ta, String

  attribute :phone, String
  attribute :email, String

  attribute :tertiary_student, Virtus::Attribute::Boolean
  attribute :tertiary_institution, String

  attribute :item_ids, Array[Integer]

  attribute :further_contact_requested, Integer

  attribute :confirm_personal_order

  validates :title, :first_name, :last_name, :address, presence: true
  validate :contains_at_least_one_item

  validates :confirm_personal_order, acceptance: {accept: true}

  def order_attr_keys
    %w{item_ids}
  end

  def customer_attr_keys
    %w{title first_name last_name address suburb city_town post_code pxid dpid x y  ta phone email tertiary_student tertiary_institution further_contact_requested}
  end

  def order_attributes
    attributes.stringify_keys.slice(*order_attr_keys)
  end

  def customer_attributes
    attributes.stringify_keys.slice(*customer_attr_keys)
  end

  def item_ids=(item_ids)
    super item_ids.reject(&:blank?)
  end

  def contact_wanted_value
    Customer.further_contact_requesteds[:wanted]
  end

  def contact_not_specified_value
    Customer.further_contact_requesteds[:not_specified]
  end

  private

  def contains_at_least_one_item
    errors.add(:item_ids, :cant_be_empty) if item_ids.none?
  end
end
