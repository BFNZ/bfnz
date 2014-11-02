require 'rails_helper'

feature 'Managing coordinators' do
  let(:hamilton) { TerritorialAuthority.find_by_code("016") }

  background do
    User.make!(:coordinator, name: "Sam Smith", territorial_authorities: [hamilton])
    login_as_admin
  end

  scenario "Viewing existing coordinators" do
    visit "/admin/coordinators"
    expect(page).to have_text("Hamilton City Sam Smith")
  end

  scenario "Adding a coordinator" do
    visit "/admin/coordinators"
    click_link "Add Coordinator"
    expect(page).to have_text("Add Coordinator")

    fill_in "Name", with: "John Johnson"
    fill_in "Email", with: "jonny@johnson.com"
    check "Auckland"
    click_button "Save"
    expect(page).to have_text("Coordinator created successfully.")
    expect(page).to have_text("Auckland John Johnson")
  end

  scenario "Editing a coordinator" do
    visit "/admin/coordinators"
    expect(page).to have_text "Sam Smith"

    click_link "Edit"
    expect(page).to have_text "Edit Coordinator"

    uncheck "Hamilton City"
    check "Waikato District"
    click_button "Save"

    expect(page).to have_text "Waikato District Sam Smith"
    expect(page).not_to have_text "Hamilton City Sam Smith"
  end
end
