require 'rails_helper'

feature 'Placing an order' do
  scenario "A user places an order" do
    visit "/orders/new"
    expect(page).to have_text("Free Order")
    select "Nelson", from: "District"
    click_button "Order"
  end
end
