class UsersController < ApplicationController
  before_action :confirm_user_logged_in,  only: [:index, :edit, :update, 
                                                 :destroy]
  before_action :confirm_correct_user,    only: [:edit, :udpate]
  before_action :confirm_admin_user,      only: :destroy

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.activities.paginate(page: params[:page])
  end

  def new
    if logged_in? # Don't let users who are already logged in sign up
      flash[:warning] = "Users who are already logged in cannot create new " +
                        "accounts."
      redirect_to current_user
    else 
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

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Successfully updated profile"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :strava_id,
                                   :password, :password_confirmation)
    end

    # before_action filters

    # Checks that a user is logged in before allowing access to a page.
    def confirm_user_logged_in
      unless logged_in?
        store_url # So that user is sent to the same URL after they log in
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

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
