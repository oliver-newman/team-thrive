class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  # Callable 404 renderer for controllers
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
