module Admin
  class OrderSearchForm < BaseForm

    attr_accessor :first_name, :last_name, :item_ids, :shipped, :id, :phone, :email, :address, :suburb, :city_town, :created_at_from, :created_at_to, :shipped_at_from, :shipped_at_to, :further_contact_requested, :customer_id, :creator_email, :district

    def initialize(params = {})
      params ||= {}
      params.each do |key, value|
        setter_method = "#{key}="
        if respond_to?(setter_method)
          send(setter_method, value)
        else
          instance_variable_set("@#{key}", value)
        end
      end
      self.shipped = parse_boolean_value(shipped) # Rails forms submit boolean values as strings
    end

    def created_at_from=(created_at_from)
      @created_at_from = parse_date(created_at_from)
    end

    def created_at_to=(created_at_to)
      @created_at_to = parse_date(created_at_to)
    end

    def shipped_at_from=(shipped_at_from)
      @shipped_at_from = parse_date(shipped_at_from)
    end

    def shipped_at_to=(shipped_at_to)
      @shipped_at_to = parse_date(shipped_at_to)
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

    def district_options
      TerritorialAuthority.order(:name).pluck(:name, :id)
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
      {
        'customer_id' => customer_id,
        'first_name' => first_name,
        'last_name' => last_name,
        'address' => address,
        'suburb' => suburb,
        'city_town' => city_town,
        'phone' => phone,
        'email' => email,
        'district' => district,
        'further_contact_requested' => further_contact_requested.presence&.to_i
      }
    end

    def order_attributes
      { 'item_ids' => item_ids,
        'id' => id
      }
    end
  end
end
