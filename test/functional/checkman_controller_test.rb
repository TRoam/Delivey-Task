require 'test_helper'

class CheckmanControllerTest < ActionController::TestCase
  test "should get improt" do
    get :improt
    assert_response :success
  end

end
