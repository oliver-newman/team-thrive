require 'test_helper'

class ErrorsControllerTest < ActionDispatch::IntegrationTest
  test "should get 400 error page" do
    get '/404'
    assert_response :success
  end

  test "should get 500 error page" do
    get '/500'
    assert_response :success
  end
end
