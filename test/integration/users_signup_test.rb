require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information does not create new user" do
    get signup_path
    assert_select 'form[action="/signup"]'
    assert_no_difference 'User.count' do
      post users_path, params: { user: { first_name: "Foo",
                                         last_name: "",
                                         email: "user@invalid",
                                         strava_id: 5882007,
                                         password: "bar",
                                         password_confirmation: "baz" } }
    end
    assert_template 'users/new'
    assert_select 'div#error-explanation'
  end

  test "valid signup creates new user" do
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { first_name: "Test",
                                         last_name: "User",
                                         email: "user@example.com",
                                         strava_id: 5882007,
                                         password: "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert is_logged_in?
  end
end
