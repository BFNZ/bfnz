class Form::Admin::OrderSearch
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
  attribute :include_duplicates, Virtus::Attribute::Boolean, default: false
  attribute :further_contact_requested, Virtus::Attribute::Boolean

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

  def yes_no_options
    [["Yes", true], ["No", false]]
  end

  def item_ids=(item_ids)
    super item_ids.map(&:to_i).reject { |id| id.zero? }
  end

  def filtered_orders
    orders = ::Order.includes(:customer).joins(:customer).order('orders.created_at desc')

    customer_attributes.each do |key, value|
      orders = orders.merge(Customer.public_send(key, value)) if value.present?
    end

    order_attributes.each do |key, value|
      orders = orders.public_send(key, value) if value.present?
    end
    orders = further_contact_flag(orders)
    orders = filter_duplicates(orders)
    orders = created_between(orders)
    orders = shipped_between(orders)
    orders
  end

  private

  def further_contact_flag(scope)
    if [true, false].include?(further_contact_requested)
      scope.merge(Customer.further_contact_requested(further_contact_requested))
    else
      scope
    end
  end

  def parse_date(date)
    Date.parse(date)
  rescue ArgumentError
    nil
  end

  def filter_duplicates(orders)
    if include_duplicates
      orders
    else
      orders.where(duplicate: false)
    end
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

  def customer_attributes
    attributes.slice(:first_name, :last_name, :email, :phone, :address, :suburb, :city)
  end

  def order_attributes
    attributes.slice(:item_ids, :shipped, :id)
  end
end
