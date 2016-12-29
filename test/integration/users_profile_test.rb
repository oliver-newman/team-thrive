require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:oliver)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.full_name)
    assert_select 'h1', text: @user.full_name
    assert_select 'h1>img.gravatar'
    assert_select 'div.pagination'
    @user.activities.paginate(page: 1).each do |activity|
      assert_match activity.title, response.body
    end
  end
end
