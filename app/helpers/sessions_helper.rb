module SessionsHelper
  # Start a session when a user logs in
  def log_in(user)
    # Uses the rails session method to save key-value pair as a cookie
    session[:user_id] = user.id
  end

  # Returns the current logged-in user (if any)
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # Returns true if user is logged in, false otherwise
  def logged_in?
    !current_user.nil?
  end
end
