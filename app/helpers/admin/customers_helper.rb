module Admin::CustomersHelper
  def contact_requested_options_for_select
    Customer.further_contact_requesteds.map { |k,v| [k.humanize, v] }
  end
end
