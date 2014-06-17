require 'rails_helper'

feature 'Authenticating an admin user' do
  background do
    User.create!(email: 'user@email.com', password: 'p@55w0rd', password_confirmation: 'p@55w0rd')
  end

  scenario "An unauthenticated user visits an admin page" do
    visit "/admin"
    expect(page).to have_text "You must be logged in"

    fill_in "Email", with: 'user@email.com'
    fill_in "Password", with: "p@55w0rd"
    click_button "Log in"

    expect(page).to have_text "BFNZ Administration"
    expect(page).to have_link "Logout"

    click_link "Logout"
    expect(current_path).to eq "/"
  end
end
