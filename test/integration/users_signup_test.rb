require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information does not create new user" do
    get signup_path
    assert_select 'form[action="/signup"]'
    assert_no_difference 'User.count' do
      # TODO: bad signup with Strava
    end
    assert_template 'users/new'
    assert_select 'div#error-explanation'
  end

  test "valid signup with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      # TODO: valid signup with Strava
    end
    # Check that exactly one email was sent since clear in setup
    assert_equal 1, ActionMailer::Base.deliveries.size

    user = assigns(:user)
    assert_not user.activated?

    # Try to log in before activating account
    log_in_as(user) 
    assert_not is_logged_in?

    # Try activating with an invalid token
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?

    # Valid token but the wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?

    # Valid token AND correct email
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert is_logged_in?
  end
end
