class Admin::ContactListCsvPresenter
  def initialize(contact_list)
    @contact_list = contact_list
  end

  def coordinator_name
    coordinator.name
  end

  def coordinator_email
    coordinator.email
  end

  def contacts
    contact_list.customers.map { |customer| Admin::ContactPresenter.new(customer) }
  end

  private

  attr_reader :contact_list

  def territorial_authority
    contact_list.territorial_authority
  end

  def coordinator
    territorial_authority.coordinator
  end
end
