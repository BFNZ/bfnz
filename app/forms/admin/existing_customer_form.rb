module Admin
  class ExistingCustomerForm < BaseForm

    attr_accessor :title, :first_name, :last_name, :address, :suburb, :city_town, 
                  :post_code, :pxid, :dpid, :x, :y, :ta, :bad_address, :phone, :email, 
                  :tertiary_student, :tertiary_institution, :admin_notes, 
                  :further_contact_requested

    attr_reader :customer, :confirm_personal_order

    validates :first_name, :last_name, :ta, presence: true
    validates :confirm_personal_order, acceptance: true



    CUSTOMER_ATTRS = %w{title first_name last_name address suburb city_town post_code pxid dpid x y  ta bad_address phone email tertiary_student tertiary_institution further_contact_requested admin_notes}

    def initialize(customer:, form_params: nil)
      @customer = customer
      super(form_params || customer_attributes)
    end

    def date_created
      customer.created_at.to_date.to_fs(:display)
    end

    private

    def customer_attributes
      customer.attributes.symbolize_keys.slice(*CUSTOMER_ATTRS.map(&:to_sym))
    end
  end
end
