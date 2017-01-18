ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
require 'webmock/minitest'
require 'net/http'

Minitest::Reporters.use!
WebMock.disable_net_connect!(allow_localhost: true)


# For recording and replaying Strava API responses
VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/.cassettes'
  c.hook_into :webmock
end


class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include ApplicationHelper

  # Returns true if a test user is logged in.
  def is_logged_in?
    !session[:user_id].nil?
  end

  # Log in as a particular user
  def log_in_as(user)
    session[:user_id] = user.id
  end
end


class ActionDispatch::IntegrationTest
  # Login in as a particular user
  # TODO: integrate with Strava
  def log_in_as(user)
    VCR.use_cassette('strava_auth') do
      response = Net::HTTP.get("https://www.strava.com/oauth/authorize?" +
        "client_id=#{Rails.application.secrets.STRAVA_CLIENT_ID}" +
        "&redirect_uri=#{strava_auth_url}" +
        "&state=1" +
        "&response_type=code")
      post login_path, params: { code: response["code"] }
    end
  end
end
