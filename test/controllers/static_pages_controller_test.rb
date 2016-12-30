require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:oliver)
    @base_title = "TeamThrive"
  end

  test "should get root" do
    get root_path
    assert_response :success # :success = "200 OK" (HTTP status code)
    # Checks the content of the HTML title element
    assert_select "title", "#{@base_title}"
  end

  test "should get help" do
    get help_path
    assert_response :success
    assert_select "title", "Help | #{@base_title}"
  end

  test "should get about" do
    get about_path
    assert_response :success
    assert_select "title", "About | #{@base_title}"
  end

  test "should get feed" do
    log_in_as @user
    get feed_path
    assert_response :success
    assert_select "title", "Feed | #{@base_title}"
  end

  test "should redirect feed when not logged in" do
    get feed_path
    assert_redirected_to login_url
  end
end
