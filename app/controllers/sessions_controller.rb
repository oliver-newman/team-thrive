class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        log_in @user    # Temporary session cookie
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_back_or_to @user
      else
        flash[:warning] = "Your account has not yet been activated. Check " +
                          "your email for the activation link."
        redirect_to root_url
      end
    else
      # Login failed
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
