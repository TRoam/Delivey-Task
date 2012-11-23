require 'test_helper'

class DoneCriteriaControllerTest < ActionController::TestCase
  setup do
    @done_criterium = done_criteria(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:done_criteria)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create done_criterium" do
    assert_difference('DoneCriterium.count') do
      post :create, done_criterium: {  }
    end

    assert_redirected_to done_criterium_path(assigns(:done_criterium))
  end

  test "should show done_criterium" do
    get :show, id: @done_criterium
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @done_criterium
    assert_response :success
  end

  test "should update done_criterium" do
    put :update, id: @done_criterium, done_criterium: {  }
    assert_redirected_to done_criterium_path(assigns(:done_criterium))
  end

  test "should destroy done_criterium" do
    assert_difference('DoneCriterium.count', -1) do
      delete :destroy, id: @done_criterium
    end

    assert_redirected_to done_criteria_path
  end
end
