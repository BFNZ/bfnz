class Admin::ContactLists::ContactListView
  def initialize(contact_list)
    @contact_list = contact_list
  end

  def id
    contact_list.id
  end

  def district_name
    contact_list.territorial_authority.name
  end

  def first_downloaded
    contact_list.created_at.to_s(:display)
  end

  def customer_count
    contact_list.customers.count
  end

  private

  attr_reader :contact_list
end
