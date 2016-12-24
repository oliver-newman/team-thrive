require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:oliver)
    @non_admin = users(:bob)
    @non_activated_user = users(:not_activated)
  end

  test "index as non-admin with pagination" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

  test "index as admin with pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count: 2
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      unless user == @non_activated_user
        assert_select 'a[href=?]', user_path(user), text: user.full_name
        unless user == @admin
          assert_select 'a[href=?]', user_path(user), text: 'delete'
        end
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test "only activated users appear in index" do
    get users_path
    assert_select 'a[href=?]', user_path(@non_activated_user), count: 0
  end
end
