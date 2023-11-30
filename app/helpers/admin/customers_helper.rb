module Admin::CustomersHelper
  def contact_requested_options_for_select
    Customer.further_contact_requesteds.map { |k,v| [k.humanize, v] }
  end

  def selected_further_contact_requested(customer_form)
    return contact_requested_options_for_select.assoc(customer_form.further_contact_requested.capitalize.tr("_", " ")).last if customer_form.present?
    contact_requested_options_for_select
  end
end
