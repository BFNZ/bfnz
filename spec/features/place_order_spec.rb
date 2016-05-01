require 'rails_helper'

feature 'Placing an order', js: true do
  scenario "A user places a valid order" do
    visit "/orders/new"
    expect(page).to have_text("Free Order")

    select "Mr", from: "Title"
    fill_in "First Name", with: "John"
    fill_in "Last Name", with: "Doe"
    select_address("1 Short Street")
    fill_in "Phone", with: "12345678"
    fill_in "Email", with: "email@test.com"
    check "Are you a tertiary student?"
    fill_in "Tertiary institution", with: "AUT"
    select_item
    check "I am interested in receiving further contact."
    click_button "Place Order"
    expect(page).to have_text("your order will be shipped as soon as possible")
  end
end
