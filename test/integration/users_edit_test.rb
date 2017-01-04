require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:oliver)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'

    num_errors = 5
    patch user_path(@user), params: { user: { first_name: "",
                                              last_name: "" } }
    assert_template 'users/edit' # Failed edit redirects back to edit page
    assert_select "div.alert", text: /^The form contains #{num_errors} errors/
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    assert_nil session[:forwarding_url]

    first_name = "Foo"
    last_name = "Bar"
    email = "foo@example.com"
    patch user_path(@user), params: { user: { first_name: first_name,
                                              last_name: last_name } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal first_name, @user.first_name
    assert_equal last_name, @user.last_name
    assert_equal email, @user.email
  end
end
