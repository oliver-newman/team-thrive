require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:oliver)
  end

  test "password reset" do
    get new_password_reset_path
    assert_template 'password_resets/new'

    # Request password reset with invalid email
    post password_resets_path, params: { password_reset: { email: "" } }
    assert_not flash.empty?
    assert_template 'password_resets/new'

    # Email for nonextistent user
    post password_resets_path,
         params: { password_reset: { email: "notauser@gmail.com" } }
    assert_not flash.empty?
    assert_template 'password_resets/new'

    # Valid email
    post password_resets_path,
         params: { password_reset: { email: @user.email } }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url

    # Visiting password reset form
    
    user = assigns(:user)

    # Request password reset form; wrong email for reset token
    get edit_password_reset_path(user.reset_token, email: "notauser@gmail.com")
    assert_redirected_to root_url

    # Non-activated user
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)

    # Wrong token for user
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url

    # Right email and token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email

    # Submitting password reset

    # Invalid password
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password: "",
                            password_confirmation: "" } }
    assert_select 'div#error-explanation'

    # Valid password and confirmation
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password: "new_password",
                            password_confirmation: "new_password" } }
    assert is_logged_in?
    assert_nil user.reload.reset_digest
    assert_not flash.empty?
    assert_redirected_to user
  end

  test "expired token" do
    get new_password_reset_path
    post password_resets_path,
         params: { password_reset: { email: @user.email } }

    user = assigns(:user)
    get edit_password_reset_path(user.reset_token, email: user.email)

    # Force token to be expired
    user.update_attribute(:reset_sent_at, 121.minutes.ago)

    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password: "new_password",
                            password_confirmation: "new_password" } }
    assert_response :redirect
    assert_redirected_to new_password_reset_url
    follow_redirect!
    assert_match /Password reset has expired./i, response.body
  end
end
