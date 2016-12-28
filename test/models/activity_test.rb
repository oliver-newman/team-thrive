require 'test_helper'

class ActivityTest < ActiveSupport::TestCase
  def setup
    @user = users(:oliver)
    @activity = @user.activities.build(title: "Lorem ipsum", sport: "ride",
                                       start_date: Time.zone.now, distance: 4.5,
                                       elevation_gain: 8.9, moving_time: 60000,
                                       strava_activity_id: 812034044)
  end

  test "should be valid" do
    assert @activity.valid?
  end

  test "user id should be present" do
    @activity.user_id = nil
    assert_not @activity.valid?
  end

  test "title should be present" do
    @activity.title = "   "
    assert_not @activity.valid?
  end

  test "title should be at most 128 characters" do
    @activity.title = "a" * 129
    assert_not @activity.valid?
  end

  # TODO: uncomment these when hooking up Strava API
  
  # test "sport should be present" do
    # @activity.sport = nil
    # assert_not @activity.valid?
  # end
  
  # test "sport should be a run or ride" do
    # @activity.sport = "swim"
    # assert_not @activity.valid?
  # end

  # test "strava activity id should be present" do
    # @activity.strava_activity_id = nil
    # assert_not @activity.valid?
  # end

  # test "start date should be present" do
    # @activity.start_date = nil
    # assert_not @activity.valid?
  # end
  
  # test "distance should be present" do
    # @activity.distance = nil
    # assert_not @activity.valid?
  # end

  # test "distance should be non-negative" do
    # @activity.distance = -1
    # assert_not @activity.valid?
  # end

  # test "elevation gain should be present" do
    # @activity.elevation_gain = nil
    # assert_not @activity.valid?
  # end

  # test "elevation gain should be non-negative" do
    # @activity.elevation_gain = -1
    # assert_not @activity.valid?
  # end
  
  # test "moving time should be present" do
    # @activity.moving_time = nil
    # assert_not @activity.valid?
  # end

  # test "moving time should be non-negative" do
    # @activity.moving_time = -1
    # assert_not @activity.valid?
  # end
  
  test "order should be most recent first" do
    assert_equal activities(:most_recent), Activity.first
  end
end
