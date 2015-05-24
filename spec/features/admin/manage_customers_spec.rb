require 'rails_helper'

feature 'Managing customers', js: true do
  background do
    @customer = Customer.create!(title: 'Mr', first_name: 'Joe',
                                last_name: 'Smith', address: '123 Sesame Street',
                                city_town: 'Wellington', post_code: '1234',
                                ta: 'wellington')
    @order = Order.create!(customer: @customer, item_ids: [Item.first.id])
    login_as_admin
    visit "/admin"
  end

  scenario "Adding a new customer" do
    click_link "New Customer"
    expect(page).to have_text("Add a new customer")

    select "Mr", from: "Title"
    fill_in "First Name", with: "John"
    fill_in "Last Name", with: "Doe"
    select_address("1 Short Street")
    fill_in "Phone", with: "12345678"
    fill_in "Email", with: "email@test.com"
    select "Phone", from: "Method received"
    select "Unknown", from: "Method of discovery"
    check "Is the order for a tertiary student?"
    fill_in "Tertiary institution", with: "AUT"
    page.first(".image_picker_image").click
    click_button "Save and add another"
    expect(page).to have_text("Customer created successfully.")
    expect(page.current_path).to eq '/admin/customers/new'
  end

  scenario "Viewing an existing customer" do
    click_link "View Orders"
    click_link "Edit"
    expect(page).to have_text "Customer ##{@customer.id}"
    expect(page).to have_select('Title', selected: 'Mr')
    expect(page).to have_field('First Name', with: 'Joe')
    expect(page).to have_field('Last Name', with: 'Smith')
    expect(page).to have_field('Address', with: '123 Sesame Street')

    expect(page).to have_text "Order ##{@customer.id}.#{@order.id}"
  end

  scenario "Cancelling an order" do
    click_link "View Orders"
    click_link "Edit"
    expect(page).to have_text "Customer ##{@customer.id}"
    expect(page).to have_text "Order ##{@customer.id}.#{@order.id}"
    click_link "Cancel order"
    expect(page).not_to have_text "Order ##{@customer.id}.#{@order.id}"
  end

  scenario "Updating an existing cusomter" do
    click_link "View Orders"
    click_link "Edit"
    expect(page).to have_text "Customer ##{@customer.id}"
    select "Mrs", from: "Title"
    fill_in "First Name", with: "Josephine"
    click_button "Update Customer"

    expect(page).to have_text "Customer details updated successfully"
    expect(page).to have_field("First Name", with: "Josephine")
  end
end
