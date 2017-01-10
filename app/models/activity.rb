class Activity < ApplicationRecord
  default_scope -> { order(start_date: :desc) }

  enum sport: { walk: 2, run: 0, ride: 1 }

  belongs_to :user

  has_attached_file :small_map
  has_attached_file :large_map

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
  validates_attachment :small_map, content_type: {
                                     content_type: /\Aimage\/.*\z/
                                   }
  validates_attachment :large_map, content_type: {
                                     content_type: /\Aimage\/.*\z/
                                   }

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
