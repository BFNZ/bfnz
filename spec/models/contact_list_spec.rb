require 'rails_helper'

RSpec.describe ContactList do
  describe ".create_for_district" do
    subject(:create_for_district) { described_class.create_for_district(district_id, contacts) }

    let(:district_id) { TerritorialAuthority.first.id }
    let(:contacts) { Customer.make!; Customer.all }

    it "creates a new contact list with the district_id" do
      expect { create_for_district }.to change { ContactList.count }.by(1)
      expect(ContactList.last.territorial_authority_id).to eq district_id
    end

    it "sets the contact_list id on all contacts" do
      contact_list = create_for_district
      contacts.each do |contact|
        expect(contact.contact_list_id).to eq contact_list.id
      end
    end
  end
end
