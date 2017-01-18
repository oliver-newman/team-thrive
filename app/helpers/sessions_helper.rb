require 'httparty'

module SessionsHelper
  # Starts a session (when a user logs in).
  def log_in(user)
    # Uses the rails session method to save key-value pair as a temporary cookie
    session[:user_id] = user.id
  end

  # Remembers user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Returns the user corresponding to the user_id cookie, setting the temporary
  # user_id cookie equal to the persistent one, if it is not already set
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # Checks if given user is the currently logged-in user.
  def current_user?(user)
    user == current_user
  end

  # Returns true if user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  # Forgets a persistent session on the server AND client sides.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # Redirects to stored location, or to default location.
  def redirect_back_or_to(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL the user is trying to access. 
  def store_url
    session[:forwarding_url] = request.original_url if request.get?
  end

  # Connects to Strava API, exchanging code for access token and athlete data.
  def strava_access_info(code)
    HTTParty.post(
      'https://www.strava.com/oauth/token',
      body: {
        'client_id': Rails.application.secrets.STRAVA_CLIENT_ID,
        'client_secret': Rails.application.secrets.STRAVA_CLIENT_SECRET,
        'code': code
      }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    ).parsed_response
  end
end
