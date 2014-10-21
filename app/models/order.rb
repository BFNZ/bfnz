class Order < ActiveRecord::Base
  has_and_belongs_to_many :items
  belongs_to :shipment

  enum method_of_discovery: [:unknown, :uni_lit, :non_uni_lit, :other_ad, :word_of_mouth, :website]
  enum method_received: [:mail, :phone, :personally_delivered, :internet, :other]

  validates :title, :first_name, :last_name, :address, presence: true
  validate :contains_at_least_one_item

  scope :first_name, ->(first_name) { where("lower(first_name) LIKE ?", "%#{first_name.downcase}%") }
  scope :last_name, ->(last_name) { where("lower(last_name) LIKE ?", "%#{last_name.downcase}%") }
  scope :email, ->(email) { where("lower(email) LIKE ?", "%#{email.downcase}%") }
  scope :phone, ->(phone) { where("phone LIKE ?", "%#{strip_non_numeric(phone)}%") }
  scope :address, ->(address) { where("lower(address) LIKE ?", "%#{address.downcase}%") }
  scope :suburb, ->(suburb) { where("lower(suburb) LIKE ?", "%#{suburb.downcase}%") }
  scope :city_town, ->(city_town) { where("lower(city_town) LIKE ?", "%#{city_town.downcase}%") }
  scope :created_between, ->(from, to) { where("orders.created_at BETWEEN ? AND ?", from.to_time, to.to_time+1.day) }
  scope :shipped_between, ->(from, to) { joins(:shipment).where("shipments.created_at BETWEEN ? AND ?", from.to_time, to.to_time+1.day) }
  scope :id, ->(id) { where(id: id) }
  scope :shipped, ->(shipped) { shipped == 1 ? where.not(shipment_id: nil) : where(shipment_id: nil) }
  scope :item_ids, ->(item_ids) { joins(:items).where(items: {id: item_ids}) }
  scope :ready_to_ship, -> { shipped(false) }

  def ta=(ta)
    super ta.gsub(/district|city/, "").strip
  end

  def phone=(phone)
    write_attribute(:phone, self.class.strip_non_numeric(phone))
  end

  def territorial_authority
    @territorial_authority ||= TerritorialAuthority.find_by_addressfinder_name(ta)
  end

  def shipped?
    shipment_id.present?
  end

  def shipped_at
    shipment.created_at
  end

  def self.strip_non_numeric(string)
    string.gsub(/\D/, '')
  end

  private

  def contains_at_least_one_item
    errors.add(:item_ids, "You must select at least one item") if item_ids.none?
  end
end
