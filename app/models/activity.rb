class Activity < ApplicationRecord
  default_scope -> { order(start_date: :desc) }

  SPORTS = %w(ride run)

  belongs_to :user

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 128 }
  validates :start_date, presence: true
  # TODO: uncomment these when hooking up to Strava API
  # validates :sport, presence: true, inclusion: { in: SPORTS }
  # validates :strava_activity_id, presence: true
  # validates :distance, presence: true,
                       # numericality: { greater_than_or_equal_to: 0 }
  # validates :elevation_gain, presence: true,
                             # numericality: { greater_than_or_equal_to: 0 }
  # validates :moving_time, presence: true,
                          # numericality: { greater_than_or_equal_to: 0 }

  # Returns the URL of the corresponding activity on Strava.
  def strava_url
    "https://www.strava.com/activities/#{strava_activity_id}"
  end
end
