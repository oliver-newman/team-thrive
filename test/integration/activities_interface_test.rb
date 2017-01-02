require 'test_helper'

class ActivitiesInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:oliver)
    @other_user = users(:bob)
  end

  test "activity interface" do
    log_in_as(@user)
    get feed_path
    assert_select 'div.pagination'

    # Invalid activity submission
    get new_activity_path
    assert_no_difference 'Activity.count' do
      post activities_path, params: { activity: { title: "" } }
    end
    assert_select 'div#error-explanation'

    # Valid activity submission
    title = "Super duper early morning test ride"
    assert_difference 'Activity.count', 1 do
      post activities_path, params: { activity: { title: title,
                                                  sport: :ride,
                                                  distance: 500,
                                                  moving_time: 400,
                                                  elevation_gain: 400,
                                                  start_date: Time.zone.now } }
    end
    assert_redirected_to activity_path(@user.activities.order(created_at: :desc).first) 
    follow_redirect!
    assert_match title, response.body

    # Delete activity
    get activity_path(@user.activities.first)
    assert_select 'input.btn-danger[value=?]', 'Delete Activity'
    assert_difference 'Activity.count', -1 do
      delete activity_path(@user.activities.first)
    end

    # Visit different user's activity
    get activity_path(@other_user.activities.first)
    assert_select 'input.btn-danger[value=?]', 'Delete Activity', count: 0
  end
end
