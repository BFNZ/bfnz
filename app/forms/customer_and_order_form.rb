class CustomerAndOrderForm < BaseForm

  attr_accessor :title, :first_name, :last_name, :address, :suburb, :city_town, :post_code, :pxid, :dpid, :x, :y, :ta, :phone, :email, :tertiary_student, :tertiary_institution, :item_ids, :further_contact_requested, :confirm_personal_order
  
  validates :title, :first_name, :last_name, :address, presence: true
  validates :confirm_personal_order, acceptance: true
  validate :contains_at_least_one_item

  def order_attributes
    { 'item_ids' => item_ids.reject(&:blank?) }
  end

  def customer_attributes
    {
      'confirm_personal_order' => confirm_personal_order,
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
      'phone' => phone,
      'email' => email,
      'tertiary_student' => tertiary_student,
      'tertiary_institution' => tertiary_institution,
      'item_ids' => item_ids,
      'further_contact_requested' => further_contact_requested.to_i
    }
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
