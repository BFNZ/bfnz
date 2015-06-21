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

    EditCustomerPage.new(customer) do |page|
      page.cancel_order(order)
    end
  end

  scenario "Editing an order" do
    ViewOrdersPage.new.edit("Joe")

    EditCustomerPage.new(customer) do |page|
      page.add_item_to_order(another_item, order)
    end
  end

  scenario "Create a new order" do
    ViewOrdersPage.new.edit("Joe")

    EditCustomerPage.new(customer) do |page|
      page.create_order(another_item)
    end
  end

  scenario "Merging a duplicate customer" do
    ViewOrdersPage.new.edit("Joe")

    EditCustomerPage.new(customer) do |page|
      page.merge_customer(duplicate_customer)
    end
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
