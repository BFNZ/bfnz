class Customer < ActiveRecord::Base
  has_many :orders
  belongs_to :created_by, class_name: 'User'
  belongs_to :updated_by, class_name: 'User'
  has_many :merged_customers, class_name: 'Customer', foreign_key: 'parent_id'

  validates :title, :first_name, :last_name, :address, presence: true

  normalize_attributes :first_name, :last_name, :email, :address
  normalize_attribute :phone, with: :phone

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
    where(further_contact_requested: true).where(contact_list_id: nil)
  }

  def self.strip_non_numeric(string)
    string.gsub(/\D/, '')
  end

  def ta=(ta)
    super ta.gsub(/district|city/, "").strip
    self.territorial_authority_id = territorial_authority.try(:id)
  end

  def identifier
    "##{id}"
  end

  def territorial_authority
    @territorial_authority ||= TerritorialAuthority.find_by_addressfinder_name(ta)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def has_email?
    email.present?
  end

end
