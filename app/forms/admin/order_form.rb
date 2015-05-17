module Admin
  class OrderForm < Form::Order
    attribute :method_received, String
    attribute :method_of_discovery, String

    attribute :admin_notes, String

    def initialize(form_params: nil)
      super form_params
    end

    def order_attr_keys
      super + %w{method_received method_of_discovery}
    end

    def customer_attr_keys
      super + %w{admin_notes}
    end
  end
end
