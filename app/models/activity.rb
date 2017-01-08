class Activity < ApplicationRecord
  default_scope -> { order(start_date: :desc) }

  FUNDRAISING_START_DATE = DateTime.new(2016, 1, 1, 0, 0, 0)
  DOLLARS_PER_KM = { run: 0.1, ride: 0.02, walk: 0.1}
  DOLLARS_PER_MEAL = 3.00
  OVERALL_GOAL_DOLLARS = 10000.0

  enum sport: { run: 0, ride: 1, walk: 2 }

  belongs_to :user

  validates :user_id, presence: true
  validates :strava_activity_id, presence: true
  validates :sport, presence: true
  validates :title, presence: true, length: { maximum: 128 }
  validates :start_date, presence: true
  validates :distance, presence: true,
                       numericality: { greater_than_or_equal_to: 0 }
  validates :elevation_gain, presence: true,
                             numericality: { greater_than_or_equal_to: 0 }
  validates :moving_time, presence: true,
                          numericality: { greater_than_or_equal_to: 0 }

  def dollars_raised
    distance * DOLLARS_PER_KM[sport.to_sym] / 1000.0
  end

  class << self
    def total_sport_distance(sport, earliest = FUNDRAISING_START_DATE,
                             latest = Time.zone.now)
      select { |a|
        a.sport == sport && a.start_date > earliest && a.start_date < latest
      }.sum(&:distance)
    end

    def total_dollars_raised(earliest = FUNDRAISING_START_DATE,
                             latest = Time.zone.now)
      select { |a|
        a.start_date > earliest && a.start_date < latest
      }.sum(&:dollars_raised)
    end

    def total_meals_funded
      total_dollars_raised / DOLLARS_PER_MEAL
    end

    def total_percent_progress
      total_dollars_raised / OVERALL_FUNDRAISING_GOAL
    end
  end
end
