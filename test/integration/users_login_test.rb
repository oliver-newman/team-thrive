require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  test "api connections fail" do
    uri = URI('https://strava.com')
    Net::HTTP.get(uri)
  end
end
