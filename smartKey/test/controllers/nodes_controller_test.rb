require 'test_helper'

class NodesControllerTest < ActionController::TestCase
  test "should get bind" do
    get :bind
    assert_response :success
  end

  test "should get ubind" do
    get :ubind
    assert_response :success
  end

end
