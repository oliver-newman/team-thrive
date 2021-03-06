require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(first_name: "Test",
                     last_name: "User",
                     email: "user@example.com",
                     strava_token: Faker::Crypto.sha1,
                     strava_id: 135513,
                     unit_preference: "feet",
                     fundraising_goal: 700)
  end

  test "full name should be correctly formatted" do
    assert_equal "#{@user.first_name} #{@user.last_name}", @user.full_name
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "first name should be present" do
    @user.first_name = " "
    assert_not @user.valid?
  end

  test "last name should be present" do
    @user.last_name = " "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = " "
    assert_not @user.valid?
  end

  test "first name should not be too long" do
    @user.first_name = "a" * 51
    assert_not @user.valid?
  end

  test "last name should not be too long" do
    @user.last_name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "unit preference should be present" do
    @user.unit_preference = nil
    assert_not @user.valid?
  end

  test "unit preference should be feet or meters" do
    assert_raise ArgumentError do
      @user.unit_preference = "smoots"
    end
  end

  test "distance unit should change with unit preference" do
    @user.prefers_feet!
    assert_equal @user.distance_unit, "mi"
    @user.prefers_meters!
    assert_equal @user.distance_unit, "km"
  end

  test "length unit should change with unit preference" do
    @user.prefers_feet!
    assert_equal @user.length_unit, "ft"
    @user.prefers_meters!
    assert_equal @user.length_unit, "m"
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.swapcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "FOO@bAr.com"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "authenticated? should return false for user with nil remember digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated activities should be destroyed" do
    @user.save
    @user.activities.create!(strava_activity_id: 15123412,
                             sport: "run",
                             start_date: 1.year.ago,
                             title: "Morning run",
                             distance: 5000,
                             elevation_gain: 500,
                             moving_time: 6000,
                             comments: "Ran this morning.")
    assert_difference "Activity.count", -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    oliver = users(:oliver)
    bob = users(:bob)
    oliver.unfollow(bob) if oliver.following?(bob)
    assert_not oliver.following?(bob)
    oliver.follow(bob)
    assert oliver.following?(bob)
    assert bob.followers.include?(oliver)
    oliver.unfollow(bob)
    assert_not oliver.following?(bob)
  end

  test "feed should have the right posts" do
    oliver = users(:oliver)
    bob = users(:bob)
    lee = users(:lee)
    # Sanity checks
    assert oliver.following?(bob)
    assert_not oliver.following?(lee)
    assert bob.activities.any?
    assert lee.activities.any?
    # Posts from followed user
    bob.activities.each do |post|
      assert oliver.feed.include?(post)
    end
    # Posts from unfollowed user
    lee.activities.each do |post|
      assert_not oliver.feed.include?(post)
    end
  end
end
