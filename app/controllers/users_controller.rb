require 'httparty'

class UsersController < ApplicationController
  before_action :confirm_user_logged_in, only: [:edit, :update, 
                                                :destroy, :following,
                                                :followers]
  before_action :confirm_correct_user, only: [:edit, :update]
  before_action :confirm_admin_user, only: [:destroy]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find_by(id: params[:id])
    not_found unless @user
    @activities = @user.activities.paginate(page: params[:page])
    @show_follow = false
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to TeamThrive!"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Successfully updated profile."
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    @show_follow = true
    render 'show'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    @show_follow = true
    render 'show'
  end

  private

  def user_params
    params.require(:user).permit(:first_name,
                                 :last_name,
                                 :email,
                                 :strava_token,
                                 :strava_id,
                                 :unit_preference)
  end

  # before_action filters

  # Checks that correct user is logged in before allowing access to a page.
  def confirm_correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # Checks that current user is an admin.
  def confirm_admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
