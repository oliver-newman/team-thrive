require 'httparty'

class UsersController < ApplicationController
  before_action :confirm_user_logged_in, only: [:index, :edit, :update, 
                                                :destroy, :following,
                                                :followers]
  before_action :confirm_correct_user, only: [:edit, :udpate]
  before_action :confirm_admin_user, only: [:destroy]

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find_by(id: params[:id])
    not_found unless @user && @user.activated?
    @activities = @user.activities.paginate(page: params[:page])
    @show_follow = false
  end

  def new
    if logged_in? # Don't let users who are already logged in sign up
      flash[:warning] = "Users who are already logged in cannot create new " +
                        "accounts."
      redirect_to current_user
    else 
      @strava_auth_url = "https://www.strava.com/oauth/authorize?client_id=" +
                         "#{Rails.application.secrets.STRAVA_CLIENT_ID}" +
                         "&redirect_uri=#{strava_auth_url}" +
                         "&response_type=code"
      @user = User.new
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "A message with a confirmation link has been sent to " +
                     "your email address. Please follow the link to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def strava_auth
    @code = params[:code]
    @strava_response = HTTParty.post(
      "https://www.strava.com/oauth/token",
      body: {
        client_id: Rails.application.secrets.STRAVA_CLIENT_ID,
        client_secret: Rails.application.secrets.STRAVA_CLIENT_SECRET,
        code: @code
      }.to_json,
      headers: {'Content-Type'=>'application/json'}
    )
    access_token = @strava_response.parsed_response[:access_token]
    strava_athlete = @strava_response.parsed_response[:athlete]

    unless (@user = User.find_by(strava_token: access_token))
      @user = User.new(
        strava_token: access_token,
        strava_id: strava_athlete[:id],
        first_name: strava_athlete[:firstname],
        last_name: strava_athlete[:lastname],
        email: strava_athlete[:email],
        unit_preference: strava_athlete[:measurement_preference]
      )
      redirect_to(root_url) unless @user.save
    end
    log_in @user
    redirect_to @user
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
    params.require(:user).permit(:first_name, :last_name, :email,
                                 :strava_token,:strava_id, :unit_preference,
                                 :password, :password_confirmation)
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
