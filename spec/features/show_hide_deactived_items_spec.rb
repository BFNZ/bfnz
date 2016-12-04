require 'rails_helper'

describe 'Show/Hide deactived items' do
  let(:active_item) { Item.active.first }
  let(:deactivated_item) { Item.where.not(deactivated_at: nil).first }

  it "Hide deactivated items to customer's new order page" do
    visit new_order_path

    expect(page).to have_text(active_item.title)
    expect(page).not_to have_text(deactivated_item.title)
  end

  describe 'Show deactivated items to admin pages' do
    let(:customer) {
      Customer.create!(title: 'Mr', first_name: 'Joe',
                       last_name: 'Smith', address: '123 Sesame Street',
                       city_town: 'Wellington', post_code: '1234',
                       ta: wellington.name)
    }
    let(:wellington) { TerritorialAuthority.find_by_code("047") }
    let!(:order) { Order.create!(customer: customer, item_ids: [Item.first.id]) }

    before(:each) do
      login_as_admin
    end

    it "new customer" do
      visit new_admin_customer_path

      expect(page).to have_text(active_item.title)
      expect(page).to have_text(deactivated_item.title)
    end

    it "edit customer existing order" do
      visit edit_admin_customer_path(customer)

      within ".new_admin_existing_order_form" do
        expect(page).to have_text(active_item.title)
        expect(page).to have_text(deactivated_item.title)
      end
    end

    it "edit customer new order", js: true do
      visit edit_admin_customer_path(customer)

      click_link "Add new order"
      within "#new_admin_new_order_form" do
        expect(page).to have_text(active_item.title)
        expect(page).to have_text(deactivated_item.title)
      end
    end
  end
end
