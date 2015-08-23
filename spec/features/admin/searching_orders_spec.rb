require 'rails_helper'

feature 'Searching orders' do
  let(:joseph) do
    Customer.create!(title: 'Mr', first_name: 'Joseph',
                     last_name: 'Smith', address: '123 Sesame Street',
                     city_town: 'Wellington', post_code: '1234',
                     ta: 'wellington')
  end
  let(:ordered_item) { Item.first }
  let(:another_item) { Item.last }
  let!(:order) { Order.create!(customer: joseph, item_ids: [ordered_item.id]) }

  let(:josephine) do
    Customer.create!(title: 'Mrs', first_name: 'Josephine',
                     last_name: 'Smithson', address: '45 Sesame Crescent',
                     city_town: 'Wellington', post_code: '1234',
                     ta: 'wellington')
  end
  let!(:order_for_second_customer) { Order.create!(customer: josephine, item_ids: [another_item.id]) }

  background do
    login_as_admin
    visit admin_orders_path
  end

  scenario "Viewing all orders" do
    ViewOrdersPage.new do |page|
      page.assert_expected_results(2)
    end

    expect(page).to have_text("Joseph Smith")
    expect(page).to have_text("Josephine Smithson")
  end

  scenario "Searching by first name" do
    ViewOrdersPage.new do |page|
      page.search_by('First name' => "Josephine")
      page.assert_expected_results(1)

      expect(page).to have_text("Josephine Smithson")
      expect(page).not_to have_text("Joseph Smith")
    end
  end

  scenario "Exporting a CSV" do
    ViewOrdersPage.new do |page|
      page.export_to_csv
      page.assert_csv_headers
      page.assert_csv_content
    end
  end
end
