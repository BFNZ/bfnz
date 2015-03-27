require 'rails_helper'

feature 'Managing orders', js: true do
  background do
    customer = Customer.create!(title: 'Mr', first_name: 'Joe',
                                last_name: 'Smith', address: '123 Sesame Street',
                                city_town: 'Wellington', post_code: '1234',
                                ta: 'wellington')
    @order = Order.create!(customer: customer, item_ids: [Item.first.id])
    login_as_admin
    visit "/admin"
  end

  scenario "Viewing existing orders" do
    expect(page).to have_text("Joe Smith")
  end

  scenario "Adding a new order" do
    click_link "Add Order"
    expect(page).to have_text("Create Order")

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
    expect(page).to have_text("Order created successfully.")
    expect(page.current_path).to eq '/admin/orders/new'
  end

  scenario "Editing an order" do
    click_link "Edit"
    expect(page).to have_text "Update Order"
    expect(page).to have_select('Title', selected: 'Mr')
    expect(page).to have_field('First Name', with: 'Joe')
    expect(page).to have_field('Last Name', with: 'Smith')
    expect(page).to have_field('Address', with: '123 Sesame Street')
  end

  scenario "Marking an order as a duplicate" do
    click_link "Edit"
    expect(page).to have_text "Update Order"
    click_link "Mark as Duplicate"
    expect(page).to have_text "Ready to Ship Orders"
    expect(page).to have_text "Order ##{@order.id} has been marked as a duplicate and has been removed from the list of labels to download."
  end
end
