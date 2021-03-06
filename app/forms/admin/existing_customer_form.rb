module Admin
  class ExistingCustomerForm < BaseForm
    attribute :title, String
    attribute :first_name, String
    attribute :last_name, String

    attribute :address, String
    attribute :suburb, String
    attribute :city_town, String
    attribute :post_code, String
    attribute :pxid, String
    attribute :dpid, String
    attribute :x, Decimal
    attribute :y, Decimal
    attribute :ta, String
    attribute :bad_address, Virtus::Attribute::Boolean

    attribute :phone, String
    attribute :email, String

    attribute :tertiary_student, Virtus::Attribute::Boolean
    attribute :tertiary_institution, String

    attribute :admin_notes, String
    attribute :further_contact_requested, Integer

    validates :first_name, :last_name, :ta, presence: true
    validates :confirm_personal_order, acceptance: true


    attr_reader :customer

    CUSTOMER_ATTRS = %w{title first_name last_name address suburb city_town post_code pxid dpid x y  ta bad_address phone email tertiary_student tertiary_institution further_contact_requested admin_notes}

    def initialize(customer:, form_params: nil)
      @customer = customer
      super(form_params || customer_attributes)
    end

    def date_created
      customer.created_at.to_date.to_s(:display)
    end

    private

    def customer_attributes
      customer.attributes.slice(*CUSTOMER_ATTRS)
    end
  end
end
