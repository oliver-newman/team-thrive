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

  test "valid signup" do
    get signup_path
    assert_difference 'User.count', 1 do
      # TODO: valid signup with Strava
    end
    # Check that exactly one email was sent since clear in setup
    assert_equal 1, ActionMailer::Base.deliveries.size

    assert_not flash.empty?
    assert is_logged_in?
  end
end
