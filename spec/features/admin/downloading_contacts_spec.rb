require 'rails_helper'

feature 'Downloading Contacts' do
  let(:hamilton) { TerritorialAuthority.find_by_code("016") }
  let(:rotorua) { TerritorialAuthority.find_by_code("024") }
  let!(:hamilton_contact) { Customer.make!(further_contact_requested: true,
                                           territorial_authority: hamilton) }

  background do
    User.make!(:coordinator, name: "Sam Smith", territorial_authorities: [hamilton, rotorua])
    login_as_admin
    visit admin_contact_lists_path
    expect(page).to have_text("Contacts for Co-ordinators")
  end

  scenario "Viewing and downloading new contacts for a co-ordinator" do
    select "Sam Smith", from: "Co-ordinator"
    click_button "Search"

    expect(page).to have_text("New Contacts in Hamilton City")
    expect(page).to have_text(hamilton_contact.full_name)

    click_button "Download to CSV"

    header = page.response_headers['Content-Disposition']
    expect(header).to match /attachment; filename="hamilton_city_contacts.*"$/

    visit admin_contact_lists_path
    select "Sam Smith", from: "Co-ordinator"
    click_button "Search"

    expect(page).to have_text "Previously Downloaded Contact Lists"
    expect(page).to have_text "Hamilton City"
  end

end
