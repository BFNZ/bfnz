class Admin::ContactLists::IndexView
  attr_reader :coordinator

  def initialize(coordinator_id:)
    @coordinator_id = coordinator_id
  end

  def coordinator
    User.coordinators.find_by_id(coordinator_id)
  end

  def coordinators_for_select
    User.coordinators.map { |user| ["#{user.name} (#{user.new_contacts.count})", user.id] }
  end

  def new_contacts_count
    @new_contacts_count ||= contactable_customers.count
  end

  def contact_list_views
    contact_lists.map { |contact_list| Admin::ContactLists::ContactListView.new(contact_list) }
  end

  def district_views
    districts.map { |district| Admin::ContactLists::DistrictView.new(district) }
  end

  def has_contact_lists?
    contact_lists.any?
  end

  private

  attr_reader :coordinator_id

  def contactable_customers
    Customer.contactable.for_districts(district_ids)
  end

  def districts
    coordinator.territorial_authorities
  end

  def district_ids
    districts.pluck(:id)
  end

  def contact_lists
    ContactList.for_districts(district_ids)
  end
end
