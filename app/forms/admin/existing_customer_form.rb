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
    attribute :ta, String

    attribute :postal_line_1, String
    attribute :postal_line_2, String
    attribute :postal_line_3, String
    attribute :postal_line_4, String
    attribute :postal_line_5, String
    attribute :postal_line_6, String

    attribute :phone, String
    attribute :email, String

    attribute :tertiary_student, Virtus::Attribute::Boolean
    attribute :tertiary_institution, String

    attribute :admin_notes, String
    attribute :further_contact_requested, Integer

    validates :first_name, :last_name, :ta, presence: true

    attr_reader :customer

    CUSTOMER_ATTRS = %w{title first_name last_name address suburb city_town post_code pxid ta postal_line_1 postal_line_2 postal_line_3 postal_line_4 postal_line_5 postal_line_6 phone email tertiary_student tertiary_institution further_contact_requested admin_notes}

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
