module Admin
  class NewCustomerForm < BaseForm
    attribute :title, String
    attribute :first_name, String
    attribute :last_name, String

    attribute :address, String
    attribute :suburb, String
    attribute :city_town, String
    attribute :post_code, String
    attribute :pxid, String
    attribute :dpid, String
    attribute :x, Decimal
    attribute :y, Decimal
    attribute :ta, String
    attribute :bad_address, Virtus::Attribute::Boolean

    attribute :phone, String
    attribute :email, String

    attribute :tertiary_student, Virtus::Attribute::Boolean
    attribute :tertiary_institution, String
    attribute :further_contact_requested, Integer
    attribute :received_in_person, Virtus::Attribute::Boolean
    attribute :admin_notes, String

    attribute :method_received, String
    attribute :method_of_discovery, String
    attribute :item_ids, Array[Integer]

    validates :first_name, :last_name, :address, presence: true
    validate :contains_at_least_one_item

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

    def order_attr_keys
      %w{item_ids method_received method_of_discovery received_in_person}
    end

    def customer_attr_keys
      %w{title first_name last_name address suburb city_town post_code pxid dpid x y  ta bad_address phone email tertiary_student tertiary_institution further_contact_requested admin_notes}
    end

    def contains_at_least_one_item
      errors.add(:item_ids, :cant_be_empty) if item_ids.none?
    end
  end
end
