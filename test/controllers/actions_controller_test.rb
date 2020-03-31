require 'test_helper'

class ActionsControllerTest < ActionDispatch::IntegrationTest
  test "should get warehouse" do
    get actions_warehouse_url
    assert_response :success
  end

end
