require "test_helper"

class Admin::StockTakesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_stock_takes_index_url
    assert_response :success
  end
end
