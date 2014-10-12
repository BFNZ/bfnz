class Order < ActiveRecord::Base
  has_and_belongs_to_many :items
  belongs_to :shipment

  enum method_of_discovery: [:unknown, :uni_lit, :non_uni_lit, :other_ad, :word_of_mouth, :website]
  enum method_received: [:mail, :phone, :personally_delivered, :internet, :other]

  validates :title, :first_name, :last_name, :address, presence: true
  validate :contains_at_least_one_item

  scope :first_name, ->(first_name) { where("lower(first_name) LIKE ?", "%#{first_name.downcase}%") }
  scope :last_name, ->(last_name) { where("lower(last_name) LIKE ?", "%#{last_name.downcase}%") }
  scope :item_ids, ->(item_ids) { joins(:items).where(items: {id: item_ids}) }
  scope :shipped, ->(shipped) { shipped == 1 ? where.not(shipment_id: nil) : where(shipment_id: nil) }

  def ta=(ta)
    super ta.gsub(/district|city/, "").strip
  end

  def territorial_authority
    @territorial_authority ||= TerritorialAuthority.find_by_addressfinder_name(ta)
  end

  def shipped?
    shipment_id.present?
  end

  private

  def contains_at_least_one_item
    errors.add(:item_ids, "You must select at least one item") if item_ids.none?
  end
end
