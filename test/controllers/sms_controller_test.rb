require 'test_helper'

class SmsControllerTest < ActionController::TestCase
  test "should get check_in" do
    get :check_in
    assert_response :success
  end

end
