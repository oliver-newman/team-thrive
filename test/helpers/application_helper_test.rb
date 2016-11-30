require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal "TeamThrive", full_title
    assert_equal "Help | TeamThrive", full_title("Help")
  end
end
