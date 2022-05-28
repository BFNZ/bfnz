require 'rails_helper'

feature 'Download labels' do
  background do
    Order.make!
    Order.make!
    login_as_admin
  end

  scenario "Viewing orders ready to ship" do
    visit "/admin"
    click_link "Labels"
    expect(page).to have_text("Ready to Ship Orders")

    within 'table.ready-to-ship' do
      expect(page).to have_text("Name")
    end
  end

  scenario "Downloading labels" do
    visit "/admin"
    click_link "Labels"
    click_link "Download 2 Labels"

    header = page.response_headers['Content-Disposition']
    expect(header).to match /attachment; filename="labels.*"$/

    Order.all.each do |order|
      expect(page).to have_content order.id
    end
  end
end
