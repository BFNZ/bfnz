module Admin
  class OrderSearchForm < BaseForm
    attribute :first_name, String
    attribute :last_name, String
    attribute :item_ids, Array[Integer]
    attribute :shipped, Boolean
    attribute :id, Integer
    attribute :phone, String
    attribute :email, String
    attribute :address, String
    attribute :suburb, String
    attribute :city_town, String
    attribute :created_at_from, Date
    attribute :created_at_to, Date
    attribute :shipped_at_from, Date
    attribute :shipped_at_to, Date
    attribute :further_contact_requested, Integer
    attribute :customer_id, Integer
    attribute :creator_email, String

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

    def yes_no_options
      [["Yes", true], ["No", false]]
    end

    def further_contact_options
      Customer.further_contact_requesteds.map { |k,v| [k.humanize, v] }
    end

    def item_ids=(item_ids)
      super item_ids.map(&:to_i).reject { |id| id.zero? }
    end

    def filtered_orders
      orders = ::Order.includes(:customer).joins(:customer).order('orders.created_at desc')

      if creator_email.present?
        orders = orders.joins(:created_by).
          where("lower(users.email) = ?", creator_email.strip.downcase)
      end

      customer_attributes.each do |key, value|
        orders = orders.merge(Customer.public_send(key, value)) if value.present?
      end

      order_attributes.each do |key, value|
        orders = orders.public_send(key, value) if value.present?
      end
      orders = shipped_flag(orders)
      orders = created_between(orders)
      orders = shipped_between(orders)
      orders
    end

    private

    def shipped_flag(scope)
      if [true, false].include?(shipped)
        scope.merge(shipped ? Order.shipped : Order.ready_to_ship)
      else
        scope
      end
    end

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

    def customer_attributes
      attributes.slice(:customer_id, :first_name, :last_name, :email, :phone, :address, :suburb, :city_town, :further_contact_requested)
    end

    def order_attributes
      attributes.slice(:item_ids, :id)
    end
  end
end
