require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get home_index_url
    assert_response :success
  end

  test "should get campaign" do
    get home_campaign_url
    assert_response :success
  end

  test "should get new_campaign_user" do
    get home_new_campaign_user_url
    assert_response :success
  end

end
