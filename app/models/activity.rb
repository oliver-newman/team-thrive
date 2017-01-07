class Activity < ApplicationRecord
  default_scope -> { order(start_date: :desc) }

  DOLLARS_PER_KM = { 'run': 0.1, 'ride': 0.02 }
  DOLLARS_PER_MEAL = 3.00

  enum sport: { run: 0, ride: 1 }

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

  class << self
    def total_sport_distance(sport)
      where(sport: sport).sum(:distance)
    end

    def total_dollars_raised
      sports.map { |sport, _|
        total_sport_distance(sport) * DOLLARS_PER_KM[sport.to_sym] / 1000.0
      }.sum
    end

    def total_meals_funded
      total_dollars_raised / DOLLARS_PER_MEAL
    end
  end
end
