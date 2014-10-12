class Admin::OrderSearchForm
  include Virtus.model
  include ActiveModel::Model

  attribute :first_name, String
  attribute :last_name, String
  attribute :item_ids, Array[Integer]
  attribute :shipped, Integer

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
    attributes.each do |key, value|
      orders = orders.public_send(key, value) if value.present?
    end
    orders
  end
end
