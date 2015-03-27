class Form::Order
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

  attribute :tertiary_student, Virtus::Attribute::Boolean
  attribute :tertiary_institution, String

  attribute :item_ids, Array[Integer]

  attribute :further_contact_requested, Virtus::Attribute::Boolean

  validates :title, :first_name, :last_name, :address, presence: true
  validate :contains_at_least_one_item

  ORDER_ATTRIBUTES = %w{item_ids}
  CUSTOMER_ATTRIBUTES = %w{title first_name last_name address suburb city_town post_code pxid ta phone email tertiary_student tertiary_institution further_contact_requested}

  def order_attributes
    attributes.stringify_keys.slice(*ORDER_ATTRIBUTES)
  end

  def customer_attributes
    attributes.stringify_keys.slice(*CUSTOMER_ATTRIBUTES)
  end

  private

  def contains_at_least_one_item
    errors.add(:item_ids, "You must select at least one item") if item_ids.none?
  end
end
