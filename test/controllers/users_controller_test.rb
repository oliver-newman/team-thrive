require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:oliver)
    @user = users(:bob)
    @other_user = users(:lee)
    @non_activated_user = users(:not_activated)
  end

  test "should redirect request for index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  test "should get new" do
    get signup_path
    assert_response :success
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

  test "should redirect signup when logged in" do
    log_in_as(@user)
    get signup_path
    assert_not flash.empty?
    assert_redirected_to @user
  end
  
  test "should protect admin attribute from edits" do
    log_in_as @user
    assert_not @user.admin?
    patch user_path(@user), params: { user: { password: "password",
                                              password_confirmation: "password",
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

  test "should redirect show of non-activated user to 404" do
    log_in_as(@user)
    get user_path(@non_activated_user)
    assert_redirected_to users_url
  end

  test "should redirect show of deleted user to 404" do
    log_in_as(@admin)
    delete user_path(@other_user)
    get user_path(@other_user)
    assert_redirected_to users_url
    assert_not flash.empty?
  end
end
