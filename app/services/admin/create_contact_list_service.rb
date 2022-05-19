class Admin::CreateContactListService
  attr_reader :contact_list

  def initialize(district_id:)
    @district_id = district_id
  end

  def perform
    @contact_list = ContactList.create_for_district(@district_id, new_contacts)
  end

  private

  def new_contacts
    Customer.contactable.for_districts(@district_id)
  end
end
