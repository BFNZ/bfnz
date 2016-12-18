class Customer < ActiveRecord::Base
  has_many :orders
  belongs_to :territorial_authority
  belongs_to :created_by, class_name: 'User'
  belongs_to :updated_by, class_name: 'User'
  has_many :merged_customers, class_name: 'Customer', foreign_key: 'parent_id'

  enum further_contact_requested: [:not_specified, :not_wanted, :wanted]
  normalize_attributes :first_name, :last_name, :email, :address
  normalize_attribute :phone, with: :phone

  scope :customer_id, ->(customer_id) { where("customers.id = ?", customer_id) }
  scope :first_name, ->(first_name) { where("lower(customers.first_name) LIKE ?", "%#{first_name.downcase}%") }
  scope :last_name, ->(last_name) { where("lower(customers.last_name) LIKE ?", "%#{last_name.downcase}%") }
  scope :email, ->(email) { where("lower(customers.email) LIKE ?", "%#{email.downcase}%") }
  scope :phone, ->(phone) { where("customers.phone LIKE ?", "%#{strip_non_numeric(phone)}%") }
  scope :address, ->(address) { where("lower(customers.address) LIKE ?", "%#{address.downcase}%") }
  scope :suburb, ->(suburb) { where("lower(customers.suburb) LIKE ?", "%#{suburb.downcase}%") }
  scope :city_town, ->(city_town) { where("lower(customers.city_town) LIKE ?", "%#{city_town.downcase}%") }
  scope :further_contact_requested, ->(further_contact_requested) {
    where(further_contact_requested: further_contact_requested)
  }
  scope :contactable, -> {
    where(further_contact_requested: self.further_contact_requesteds[:wanted]).
      where(contact_list_id: nil)
  }
  scope :for_districts, ->(ids) {
    where(territorial_authority_id: ids)
  }
  scope :district, ->(id) {
    where(territorial_authority_id: id)
  }
  scope :can_ship_to, -> {
    where("further_contact_requested in (?)",
            [self.further_contact_requesteds[:not_specified],
             self.further_contact_requesteds[:wanted]]).
      where(bad_address: false)
  }

  def self.strip_non_numeric(string)
    string.gsub(/\D/, '')
  end

  # when ta name is set, also set the TA association
  def ta=(name)
    super
    self.territorial_authority = TerritorialAuthority.find_by_name(name)
  end

  def identifier
    "##{id}"
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def has_email?
    email.present?
  end
end
