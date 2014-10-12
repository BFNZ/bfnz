require 'rails_helper'

feature 'Managing orders', js: true do
  background do
    Order.create!(title: 'Mr', first_name: 'Joe', last_name: 'Smith',
                  address: '123 Sesame Street', city_town: 'Wellington',
                  post_code: '1234', ta: 'wellington', item_ids: [Item.first.id])
    login_as_admin
  end

  scenario "Viewing existing orders" do
    visit "/admin"
    expect(page).to have_text("Joe Smith")
  end

  scenario "Adding a new order" do
    visit "/admin"
    click_link "Add Order"
    expect(page).to have_text("Create Order")

    select "Mr", from: "Title"
    fill_in "order_first_name", with: "John"
    fill_in "order_last_name", with: "Doe"
    select_address("1 Short Street")
    fill_in "Phone", with: "12345678"
    fill_in "Email", with: "email@test.com"
    select "Phone", from: "Method received"
    select "Unknown", from: "Method of discovery"
    check "Is the order for a tertiary student?"
    fill_in "Tertiary institution", with: "AUT"
    page.first(".image_picker_image").click
    click_button "Save"
    expect(page).to have_text("Order created.")
  end
end
