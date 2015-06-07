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
  let(:items_select) { 'admin_existing_order_form_item_ids' }

  let(:duplicate_customer) do
    Customer.create!(title: 'Mr', first_name: 'Joseph',
                     last_name: 'Smith', address: '123 Sesame Street',
                     city_town: 'Wellington', post_code: '1234',
                     ta: 'wellington')
  end
  let!(:order_for_duplicate_customer) { Order.create!(customer: duplicate_customer, item_ids: [another_item.id]) }

  background do
    login_as_admin
    visit "/admin"
  end

  scenario "Viewing existing orders" do
    ViewOrdersPage.new

    expect(page).to have_text("Joe Smith")
  end

  scenario "Cancel an order" do
    ViewOrdersPage.new.edit("Joe")

    expect(page).to have_text "Order ##{customer.id}.#{order.id}"
    expect(page).to have_select(items_select, selected: ordered_item.title)
    click_link "Cancel order"
    expect(page).not_to have_text "Order ##{customer.id}.#{order.id}"
  end

  scenario "Editing an order" do
    ViewOrdersPage.new.edit("Joe")

    expect(page).to have_text "Order ##{customer.id}.#{order.id}"
    expect(page).to have_select(items_select, selected: ordered_item.title)
    select another_item.title, from: items_select
    click_button "Update order"
    expect(page).to have_text "Order ##{customer.id}.#{order.id} updated"
    expect(page).to have_select(items_select, selected: [ordered_item.title, another_item.title])
  end

  scenario "Merging a duplicate customer" do
    ViewOrdersPage.new.edit("Joe")

    edit_customer_page = EditCustomerPage.new(customer)

    # TODO from here
#    edit_customer_page.merge_customer(duplicate_customer)
  end

  # TODO - do we need this functionality still?
  # scenario "Marking an order as a duplicate" do
  #   click_link "Edit"
  #   expect(page).to have_text "Order ##{customer.id}.#{order.id}"
  #   click_link "Mark as Duplicate"
  #   expect(page).to have_text "Ready to Ship Orders"
  #   expect(page).to have_text "Order ##{@order.id} has been marked as a duplicate and has been removed from the list of labels to download."
  # end
end
