require 'test_helper'

class AdminControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_url
    assert_response :success
  end

  test "should redirect when user not logged in" do
    delete logout_url
    get admin_url
    assert_redirected_to login_url
  end
end
