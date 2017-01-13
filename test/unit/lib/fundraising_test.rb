require 'test_helper'

class FundraisingTest < ActionView::TestCase
  test "run and walk should have the same fundraising equivalency" do
    assert_equal DOLLARS_PER_KM[:run], DOLLARS_PER_KM[:walk]
  end
end
