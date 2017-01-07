require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:oliver)
    @user = users(:bob)
    @other_user = users(:lee)
  end

  test "should redirect request for index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { first_name: @user.first_name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should protect admin attribute from edits" do
    log_in_as(@user)
    assert_not @user.admin?
    patch user_path(@user), params: { user: { last_name: "blahblahblah",
                                              admin: true } }
    assert_not @user.reload.admin?
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference "User.count" do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@user)
    assert_no_difference 'User.count' do
      delete user_path(@other_user)
    end
    assert_redirected_to root_url
  end

  test "should redirect show of deleted user to 404" do
    log_in_as(@admin)
    other_user_path = user_path(@other_user)
    delete user_path(@other_user)
    assert_raises ActionController::RoutingError do
      get other_user_path
    end
  end

  test "should redirect following page when not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  test "should redirect followers page when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end
end
