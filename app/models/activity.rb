class Activity < ApplicationRecord
  default_scope -> { order(start_date: :desc) }

  BIKE_DOLLARS_PER_METER = 0.00006215
  RUN_DOLLARS_PER_METER = 0.0002486

  enum sport: { run: 0, ride: 1 }

  belongs_to :user

  validates :user_id, presence: true
  validates :sport, presence: true
  validates :title, presence: true, length: { maximum: 128 }
  validates :start_date, presence: true

  # TODO: uncomment these when hooking up to Strava API
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

  def map_url(size)
    "https://www.maps.googleapis.com/maps/api/staticmap?size=#{size}x#{size}" +
      "&path=weight:3%color:blue%7:Cenc:#{CGI::escape(summary_polyline)}" +
      "&key=#{Rails.application.config.GOOGLE_MAPS_KEY}"
  end
end
