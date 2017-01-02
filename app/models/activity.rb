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
  validates :distance, presence: true,
                       numericality: { greater_than_or_equal_to: 0 }

  # TODO: uncomment these when hooking up to Strava API
  # validates :strava_activity_id, presence: true
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
      "&key=#{Rails.application.secrets.GOOGLE_MAPS_KEY}"
  end

  def moving_time_formatted
    self.class.formatted_time(moving_time)
  end

  # Converts a raw distance (in meters) to miles or km depending on the
  # unit preference of user (defaults to miles), and formats as a string with
  # units.
  def distance_formatted_for(user = nil)
    raw_distance = Unit.new("#{distance} m")
    distance_unit = user.nil? ? "mi" : user.distance_unit

    converted_distance = raw_distance.convert_to(distance_unit)
    converted_distance.round(1)
  end

  # Converts a raw elevation gain (in meters) to feet or meters depending on
  # the unit preference of user (defaults to feet), and formats as a
  # string with units.
  def elevation_gain_formatted_for(user = nil)
    raw_gain = Unit.new("#{elevation_gain} m")
    length_unit = user.nil? ?  "ft" : user.length_unit

    converted_gain = raw_gain.convert_to(length_unit)
    converted_gain.round(0)
  end

  class << self
    # Takes an elapsed time in raw seconds and convertes it to a time of the
    # form HH:MM:SS.
    def formatted_time(raw_seconds)
      seconds = (raw_seconds % 60).to_i
      minutes = (raw_seconds / 60).to_i % 60
      hours = (raw_seconds / 3600).to_i

      if hours.zero? && minutes.zero?
        "#{seconds}s"
      elsif hours.zero?
        "#{minutes}:#{zero_pad(seconds)}"
      else
        "#{hours}:#{zero_pad(minutes)}:#{zero_pad(seconds)}"
      end
    end

    def zero_pad(num)
      num.to_s.rjust(2, '0')
    end
  end
end
