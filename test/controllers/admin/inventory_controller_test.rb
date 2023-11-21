require "test_helper"

class Admin::InventoryControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_inventory_index_url
    assert_response :success
  end
end
