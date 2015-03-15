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

  def orders
    contact_list.orders.map { |order| Admin::ContactPresenter.new(order) }
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
