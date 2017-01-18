require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:oliver)
  end

  test "non logged in layout links" do
    get root_path
    assert_template 'static_pages/welcome'
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", about_path
    assert_select "form[action=?]", login_url
    assert_select "a[href=?]", new_activity_path, count: 0
    assert_select "a[href=?]", users_path, count: 0
    assert_select "a[href=?]", edit_user_path(@user), count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "logged in layout links" do
    log_in_as(@user)
    assert is_logged_in?
    get dashboard_path
    assert_template 'activities/dashboard'
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", dashboard_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", new_activity_path
    assert_select "a[href=?]", edit_user_path(@user)
    assert_select "a[href=?]", user_path(@user)
  end
end
