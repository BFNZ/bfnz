class Admin::ContactLists::DistrictView
  def initialize(district)
    @district = district
  end

  def has_new_contacts?
    contacts.any?
  end

  def name
    district.name
  end

  def district_id
    district.id
  end

  def contact_views
    contacts.map do |contact|
      Admin::ContactLists::ContactView.new(contact)
    end
  end

  def contacts
    Customer.contactable.for_districts(district.id).order('created_at desc')
  end

  private

  attr_reader :district
end
