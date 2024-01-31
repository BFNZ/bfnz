module Admin
  class NewCustomerForm < BaseForm

    attr_accessor :title, :first_name, :last_name, :address, :suburb, :city_town, :post_code, :pxid, :dpid, :x, :y, :ta, :bad_address, :phone, :email, :tertiary_student, :tertiary_institution, :further_contact_requested, :received_in_person, :admin_notes, :method_received, :method_of_discovery, :item_ids

    validates :first_name, :last_name, :ta, presence: true
    validate :contains_at_least_one_item

    def order_attributes
      {
        item_ids: item_ids,
        method_received: method_received,
        method_of_discovery: method_of_discovery,
        received_in_person: parse_boolean_value(received_in_person)
      }
    end

    def customer_attributes
      {
        'title' => title,
        'first_name' => first_name,
        'last_name' => last_name,
        'address' => address,
        'suburb' => suburb,
        'city_town' => city_town,
        'post_code' => post_code,
        'pxid' => pxid,
        'dpid' => dpid,
        'x' => x,
        'y' => y,
        'ta' => ta,
        'bad_address' => parse_boolean_value(bad_address),
        'phone' => phone,
        'email' => email,
        'tertiary_student' => parse_boolean_value(tertiary_student),
        'tertiary_institution' => tertiary_institution,
        'admin_notes' => admin_notes,
        'further_contact_requested' => further_contact_requested.to_i
      }
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
