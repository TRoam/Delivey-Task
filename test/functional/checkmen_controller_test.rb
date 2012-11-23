require 'test_helper'

class CheckmenControllerTest < ActionController::TestCase
  setup do
    @checkman = checkmen(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:checkmen)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create checkman" do
    assert_difference('Checkman.count') do
      post :create, checkman: {  }
    end

    assert_redirected_to checkman_path(assigns(:checkman))
  end

  test "should show checkman" do
    get :show, id: @checkman
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @checkman
    assert_response :success
  end

  test "should update checkman" do
    put :update, id: @checkman, checkman: {  }
    assert_redirected_to checkman_path(assigns(:checkman))
  end

  test "should destroy checkman" do
    assert_difference('Checkman.count', -1) do
      delete :destroy, id: @checkman
    end

    assert_redirected_to checkmen_path
  end
end
