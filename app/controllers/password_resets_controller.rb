class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    email = params[:password_reset][:email].downcase
    @user = User.find_by(email: email)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "A message with a password reset link has been sent to " +
                     "#{email}. Please follow the link to reset your password."
      redirect_to root_url
    else
      flash.now[:danger] = "We could not find an account associated with " +
                           "the email address #{email}."
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = "Your password has been reset."
      redirect_to @user
    else # Invalid new password
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  # Before filters

  def get_user
    @user = User.find_by(email: params[:email])
  end

  # Makes sure that user exists, is activated, and that password reset tokens
  # match.
  def valid_user
    unless (@user && @user.activated? &&
            @user.authenticated?(:reset, params[:id]))
      redirect_to root_url
    end
  end

  # Checks that password reset token has not expired.
  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = "Password reset has expired."
      redirect_to new_passord_reset_url
    end
  end
end
