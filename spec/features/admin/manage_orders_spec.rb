require 'rails_helper'

feature 'Managing orders', js: true do
  let(:customer) do
    Customer.create!(title: 'Mr', first_name: 'Joe',
                     last_name: 'Smith', address: '123 Sesame Street',
                     city_town: 'Wellington', post_code: '1234',
                     ta: 'wellington')
  end
  let(:ordered_item) { Item.first }
  let(:another_item) { Item.last }
  let!(:order) { Order.create!(customer: customer, item_ids: [ordered_item.id]) }

  background do
    login_as_admin
    visit "/admin"
    click_link "View Orders"
  end

  scenario "Viewing existing orders" do
    expect(page).to have_text("Joe Smith")
  end

  scenario "Cancel an order" do
    click_link "Edit"
    expect(page).to have_text "Order ##{customer.id}.#{order.id}"
    expect(page).to have_select('item_ids', selected: "#{ordered_item.title}")
    click_link "Cancel order"
    expect(page).not_to have_text "Order ##{customer.id}.#{order.id}"
  end

  scenario "Editing an order" do
    click_link "Edit"
    expect(page).to have_text "Order ##{customer.id}.#{order.id}"
    expect(page).to have_select('item_ids', selected: "#{ordered_item.title}")
    select another_item.title, from: "item_ids"
    # TODO update the order
  end

  #TODO fix
  # scenario "Marking an order as a duplicate" do
  #   click_link "Edit"
  #   expect(page).to have_text "Update Order"
  #   click_link "Mark as Duplicate"
  #   expect(page).to have_text "Ready to Ship Orders"
  #   expect(page).to have_text "Order ##{@order.id} has been marked as a duplicate and has been removed from the list of labels to download."
  # end
end
