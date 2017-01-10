module Fundraising
  FUNDRAISING_START_DATE = DateTime.new(2017, 1, 1, 0, 0, 0)
  FUNDRAISING_END_DATE = DateTime.new(2018, 1, 1, 0, 0, 0)
  DOLLARS_PER_KM = { run: 0.1, ride: 0.02, walk: 0.1}
  DOLLARS_PER_MEAL = 3.00
  OVERALL_GOAL_DOLLARS = 10000.0

  # User instance methods

  # Distance (in meters) traveled by a user (optionally, 
  def distance_travelled_by(user, sport = nil,
                            earliest = FUNDRAISING_START_DATE,
                            latest = FUNDRAISING_END_DATE)
    # This ugliness is required because underlying sport column is an enum and
    # thus sport strings do not cooperate when interpolated into raw SQL
    # queries. And to allow for nil sport.
    (sport.nil? ? user.activities : user.activities.where(sport: sport)).where(
      "start_date > ? AND start_date < ?", earliest, latest
    ).sum(&:distance)
  end

  # Dollars raised by a single user (default: within the fundraising period).
  def dollars_raised_by(user, earliest = FUNDRAISING_START_DATE,
                        latest = FUNDRAISING_END_DATE)
    user.activities.where(
      "start_date > ? AND start_date < ?", earliest, latest
    ).sum { |activity| dollar_equivalency_for(activity) }
  end

  # Meals funded by a single user (default: within the fundraising period).
  def meals_funded_by(user, earliest = FUNDRAISING_START_DATE,
                      latest = FUNDRAISING_END_DATE)
    dollars_raised_by(user, earliest, latest) / DOLLARS_PER_MEAL
  end

  # Percentage of a user's fundraising goal that has been achieved.
  def percent_of_goal_raised_by(user)
    if user.fundraising_goal.positive?
      dollars_raised_by(user) / user.fundraising_goal * 100.0
    else
      0.0
    end
  end

  # Activity instance methods

  # Dollars raised over the course of a single activity.
  def dollar_equivalency_for(activity)
    DOLLARS_PER_KM[activity.sport.to_sym] * activity.distance / 1000.0
  end

  # Meals funded over the course of a single activity.
  def meal_equivalency_for(activity)
    dollar_equivalency_for(activity) / DOLLARS_PER_MEAL
  end

  # Overall methods

  # Distance traveled over the course of activities of a specific sport.
  def sport_distance_overall(sport, earliest = FUNDRAISING_START_DATE,
                             latest = FUNDRAISING_END_DATE)
    Activity.where(sport: sport).where(
      "start_date > ? AND start_date < ?", earliest, latest
    ).sum(:distance)
  end

  # Total dollars raised by all users.
  def dollars_raised_overall(earliest = FUNDRAISING_START_DATE,
                             latest = FUNDRAISING_END_DATE)
    Activity.where(
      "start_date > ? AND start_date < ?", earliest, latest
    ).sum { |activity| dollar_equivalency_for(activity) }
  end

  # Total meals funded by all users.
  def meals_funded_overall(earliest = FUNDRAISING_START_DATE,
                           latest = FUNDRAISING_END_DATE)
    dollars_raised_overall(earliest, latest) / DOLLARS_PER_MEAL
  end
end
