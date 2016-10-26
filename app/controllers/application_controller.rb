class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def team_thrive
    render html: "Weclome to Team Thrive!"
  end
end
