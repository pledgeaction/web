require 'test_helper'

class SmsControllerTest < ActionController::TestCase
  test "should 200 if params are as expected" do
    response = post :checkin, params: { Body: '' }
    assert response.code == '200'
  end
end
