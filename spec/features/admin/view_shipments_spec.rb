require 'rails_helper'

feature 'View past shipments' do
  background do
    Order.make!(:shipped)
    login_as_admin
  end

  scenario "View past shipments" do
    visit "/admin"
    click_link "Shipments"
    expect(page).to have_text("Past Shipments")

    within 'table' do
      shipment = Shipment.first
      expect(page).to have_text(shipment.id)
      expect(page).to have_text(shipment.created_at.to_s(:display))
    end
  end

  scenario "Downloading past shipment" do
    visit "/admin"
    click_link "Shipments"

    within 'table' do
      click_link "Download"
    end

    header = page.response_headers['Content-Disposition']
    expect(header).to match /attachment; filename="labels.*"$/

    Order.all.each do |order|
      expect(page).to have_content order.id
    end
  end
end
