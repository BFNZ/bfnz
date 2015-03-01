class Admin::OrderSearchForm
  include Virtus.model
  include ActiveModel::Model

  attribute :first_name, String
  attribute :last_name, String
  attribute :item_ids, Array[Integer]
  attribute :shipped, Integer
  attribute :id, Integer
  attribute :phone, String
  attribute :email, String
  attribute :address, String
  attribute :suburb, String
  attribute :city, String
  attribute :created_at_from, Date
  attribute :created_at_to, Date
  attribute :shipped_at_from, Date
  attribute :shipped_at_to, Date
  attribute :duplicate, Virtus::Attribute::Boolean, default: false

  def created_at_from=(date)
    super parse_date(date)
  end

  def created_at_to=(date)
    super parse_date(date)
  end

  def shipped_at_from=(date)
    super parse_date(date)
  end

  def shipped_at_to=(date)
    super parse_date(date)
  end

  def item_ids_options
    Item.all.map { |item| [item.title, item.id] }
  end

  def shipped_options
    [["Yes", 1], ["No", 0]]
  end

  def item_ids=(item_ids)
    super item_ids.map(&:to_i).reject { |id| id.zero? }
  end

  def filtered_orders
    orders = Order.order('created_at desc')
    attributes_with_equality.each do |key, value|
      orders = orders.public_send(key, value) if value.present?
    end
    orders = orders.where(duplicate: duplicate)
    orders = created_between(orders)
    orders = shipped_between(orders)
    orders
  end

  private

  def parse_date(date)
    Date.parse(date)
  rescue ArgumentError
    nil
  end

  def created_between(orders)
    if created_at_from && created_at_to
      orders.created_between(created_at_from, created_at_to)
    else
      orders
    end
  end

  def shipped_between(orders)
    if shipped_at_from && shipped_at_to
      orders.shipped_between(shipped_at_from, shipped_at_to)
    else
      orders
    end
  end

  def attributes_with_equality
    attributes.except(:created_at_from, :created_at_to,
                      :shipped_at_from, :shipped_at_to,
                      :duplicate)
  end
end
