module FeatureHelpers
  def select_address(address)
    fill_in "Address", with: address
    find("li.af_item:first-child").click
  end

  def login_as_admin
    admin = User.make!(:admin)
    visit "/admin"
    fill_in "Email", with: admin.email
    fill_in "Password", with: admin.password
    click_button "Log in"
  end
end
