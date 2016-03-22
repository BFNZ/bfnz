class CustomerAndOrderForm < BaseForm
  attribute :title, String
  attribute :first_name, String
  attribute :last_name, String

  attribute :address, String
  attribute :suburb, String
  attribute :city_town, String
  attribute :post_code, String
  attribute :pxid, String
  attribute :ta, String

  attribute :postal_line_1, String
  attribute :postal_line_2, String
  attribute :postal_line_3, String
  attribute :postal_line_4, String
  attribute :postal_line_5, String
  attribute :postal_line_6, String

  attribute :phone, String
  attribute :email, String

  attribute :tertiary_student, Virtus::Attribute::Boolean
  attribute :tertiary_institution, String

  attribute :item_ids, Array[Integer]

  attribute :further_contact_requested, Virtus::Attribute::Boolean

  validates :title, :first_name, :last_name, :address, presence: true
  validate :contains_at_least_one_item

  def order_attr_keys
    %w{item_ids}
  end

  def customer_attr_keys
    %w{title first_name last_name address suburb city_town post_code pxid ta postal_line_1 postal_line_2 postal_line_3 postal_line_4 postal_line_5 postal_line_6 phone email tertiary_student tertiary_institution further_contact_requested}
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

  private

  def contains_at_least_one_item
    errors.add(:item_ids, :cant_be_empty) if item_ids.none?
  end
end
