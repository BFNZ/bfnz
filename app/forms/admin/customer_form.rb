module Admin
  class CustomerForm < BaseForm
    attribute :title, String
    attribute :first_name, String
    attribute :last_name, String

    attribute :address, String
    attribute :suburb, String
    attribute :city_town, String
    attribute :post_code, String
    attribute :pxid, String
    attribute :ta, String

    attribute :phone, String
    attribute :email, String

    attribute :tertiary_student, Virtus::Attribute::Boolean
    attribute :tertiary_institution, String

    attribute :admin_notes, String
    attribute :further_contact_requested, Virtus::Attribute::Boolean

    validates :title, :first_name, :last_name, :address, presence: true

    attr_reader :customer

    def initialize(customer:, form_params: nil)
      @customer = customer
      super(form_params || customer.attributes)
    end

    def date_created
      customer.created_at.to_date.to_s(:display)
    end
  end
end
