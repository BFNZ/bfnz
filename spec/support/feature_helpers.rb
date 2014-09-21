module FeatureHelpers
  def select_address(address)
    fill_in "Address", with: address
    find("li.af_item:first-child").click
  end

  def login_as_admin
    visit "/admin"
    fill_in "Email", with: 'shevaun.coker@gmail.com'
    fill_in "Password", with: 'password'
    click_button "Log in"
  end
end
