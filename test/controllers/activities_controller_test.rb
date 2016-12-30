require 'test_helper'

class ActivitiesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:oliver)
    @other_user = users(:bob)
    @activity1 = activities(:ride1)
    @activity2 = activities(:ride2)
    @activity3 = activities(:run1)
  end

  test "should redirect new when no user is logged in" do
    get new_activity_path
    assert_redirected_to login_url
  end

  test "should redirect create when no user is logged in" do
    assert_no_difference 'Activity.count' do
      post activities_path, params: { activity: { title: "Morning ride", 
                                                  sport: :ride,
                                                  start_date: Time.zone.now } }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Activity.count' do
      delete activity_path(@activity1)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as incorrect user" do
    log_in_as(@other_user)
    assert_no_difference 'Activity.count' do
      delete activity_path(@activity2)
    end
    assert_redirected_to root_url
  end

  test "should redirect to user profile after destroy" do
    log_in_as(@user)
    delete activity_path(@activity3)
    assert_redirected_to user_path(@user)
  end
end
