require 'test_helper'

class ActivitiesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @activity = activities(:ride1)
  end

  test "should redirect new when no user is logged in" do
    get new_activity_path
    assert_redirected_to login_url
  end

  test "should redirect create when no user is logged in" do
    assert_no_difference 'Activity.count' do
      post activities_path, params: { activity: { title: "Morning ride", 
                                                  start_date: Time.zone.now } }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Activity.count' do
      delete activity_path(@activity)
    end
    assert_redirected_to login_url
  end
end
