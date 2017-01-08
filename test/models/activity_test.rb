require 'test_helper'

class ActivityTest < ActiveSupport::TestCase
  def setup
    @user = users(:oliver)
    @activity = @user.activities.build(title: "Lorem ipsum", sport: "ride",
                                       start_date: Time.zone.now,
                                       distance: 10000, elevation_gain: 1000,
                                       moving_time: 60000,
                                       strava_activity_id: 812034044)
  end

  test "run and walk should have the same fundraising equivalency" do
    assert_equal Activity::DOLLARS_PER_KM[:run], Activity::DOLLARS_PER_KM[:walk]
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
    # assert_raise ArgumentError do
      # @activity.sport = "swim"
    # end
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

  test "formatting methods should convert to and format with correct units" do
    raw_dist = Unit.new("#{@activity.distance} m")
    raw_elev_gain = Unit.new("#{@activity.elevation_gain} m")

    @user.prefers_feet!
    assert_equal @activity.distance_formatted_for(@user),
                 raw_dist.convert_to("mi").round(1)
    assert_equal @activity.elevation_gain_formatted_for(@user),
                 raw_elev_gain.convert_to("ft").round(0)
    @user.prefers_meters!
    assert_equal @activity.distance_formatted_for(@user),
                 raw_dist.convert_to("km").round(1)
    assert_equal @activity.elevation_gain_formatted_for(@user),
                 raw_elev_gain.convert_to("m").round(0)
  end
end
