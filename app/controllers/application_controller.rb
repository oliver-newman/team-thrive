require 'ruby-units'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper

  # Callable 404 renderer for controllers
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
  
  private

  # Checks that a user is logged in before allowing access to a page.
  def confirm_user_logged_in
    unless logged_in?
      store_url # So that user is sent to the same URL after they log in
      flash[:danger] = "Please log in."
      redirect_to root_url
    end
  end
end
