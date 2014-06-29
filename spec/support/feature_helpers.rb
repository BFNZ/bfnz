module FeatureHelpers
  def select_address(address)
    fill_in "Address", with: address
    find("li.af_item:first-child").click
  end
end
