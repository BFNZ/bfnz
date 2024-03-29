class Order < ApplicationRecord
  has_and_belongs_to_many :items
  belongs_to :table, optional: true
  belongs_to :shipment, optional: true
  belongs_to :customer, optional: true
  belongs_to :created_by, class_name: 'User', optional: true
  belongs_to :updated_by, class_name: 'User', optional: true

  paginates_per 20

  enum :method_of_discovery, [:unknown, :mail_disc, :uni_lit, :non_uni_lit, :other_ad, :word_of_mouth, :website, :other_disc, :table_disc], prefix: :method_of_discovery
  enum :method_received, [:mail, :phone, :personally_delivered, :internet, :other, :table], prefix: :method_received

  scope :created_between, ->(from, to) { where("orders.created_at >= ? AND orders.created_at < ?", from.in_time_zone, to.in_time_zone + 1.day) }
  scope :shipped_between, ->(from, to) { joins(:shipment).where("shipments.created_at >= ? AND shipments.created_at < ?", from.in_time_zone, to.in_time_zone + 1.day) }
  scope :id, ->(id) { where(id: id) }
  scope :shipped, -> { where("orders.shipment_id IS NOT NULL") }
  scope :ready_to_ship, -> {
    where(shipment_id: nil ).joins(:customer).merge(Customer.can_ship_to)
  }
  scope :item_ids, ->(item_ids) { joins(:items).where(items: {id: item_ids}) }

  attr_writer :received_in_person

  def received_in_person?
    @received_in_person
  end

  def shipped?
    shipment_id.present?
  end

  def shipped_at
    shipment.created_at
  end

  def identifier
    "##{customer_id}.#{id}"
  end

  def item_codes
    items.map(&:code).sort.join
  end
end
