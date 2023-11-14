module Admin::CustomersHelper
  def contact_requested_options_for_select
    Customer.further_contact_requesteds.map { |k,v| [k.humanize, v] }
  end

  def selected_further_contact_requested(customer_form)
    contact_requested_options_for_select.assoc(customer_form.further_contact_requested.capitalize.tr("_", " ")).last
  end
end
