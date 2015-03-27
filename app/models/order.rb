class Order < ActiveRecord::Base
  has_and_belongs_to_many :items
  belongs_to :shipment
  belongs_to :customer
  belongs_to :created_by, class_name: 'User'
  belongs_to :updated_by, class_name: 'User'

  paginates_per 20

  enum method_of_discovery: [:unknown, :uni_lit, :non_uni_lit, :other_ad, :word_of_mouth, :website]
  enum method_received: [:mail, :phone, :personally_delivered, :internet, :other]

  scope :created_between, ->(from, to) { where("orders.created_at BETWEEN ? AND ?", from.to_time, to.to_time+1.day) }
  scope :shipped_between, ->(from, to) { joins(:shipment).where("shipments.created_at BETWEEN ? AND ?", from.to_time, to.to_time+1.day) }
  scope :id, ->(id) { where(id: id) }
  scope :shipped, ->(shipped) { shipped == 1 ? where.not(shipment_id: nil) : where(shipment_id: nil) }
  scope :duplicate, ->(duplicate) { where(duplicate: duplicate) }
  scope :item_ids, ->(item_ids) { joins(:items).where(items: {id: item_ids}) }
  scope :ready_to_ship, -> { shipped(false).duplicate(false) }

  def shipped?
    shipment_id.present?
  end

  def shipped_at
    shipment.created_at
  end

  def item_codes
    items.map(&:code).join
  end
end
