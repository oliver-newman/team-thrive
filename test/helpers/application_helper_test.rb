require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  def setup
    @user = users(:oliver)
    @activity = activities(:ride1)
  end
  
  test "full title helper" do
    assert_equal "TeamThrive", full_title
    assert_equal "Help | TeamThrive", full_title("Help")
  end

  test "formatting methods should convert to and format with correct units" do
    raw_dist = Unit.new("#{@activity.distance} m")
    raw_elev_gain = Unit.new("#{@activity.elevation_gain} m")

    @user.prefers_feet!
    assert_equal distance_formatted_for(@activity.distance, @user),
                 raw_dist.convert_to("mi").round(1)
    assert_equal elevation_gain_formatted_for(@activity.elevation_gain, @user),
                 raw_elev_gain.convert_to("ft").round(0)
    @user.prefers_meters!
    assert_equal distance_formatted_for(@activity.distance, @user),
                 raw_dist.convert_to("km").round(1)
    assert_equal elevation_gain_formatted_for(@activity.elevation_gain, @user),
                 raw_elev_gain.convert_to("m").round(0)
  end
end
