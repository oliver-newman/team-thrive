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
      "&key=#{Rails.application.secrets.GOOGLE_MAPS_KEY}"
  end

  def formatted_moving_time
    self.class.formatted_time(moving_time)
  end

  def formatted_distance(user = nil)
    preferred_units = user.nil? ?  User.units[:feet] : user.preferred_units
    distance_units = user.nil? ?  "mi" : user.distance_units
    raw_distance = Unit.new("#{distance} m")
    converted_distance = case preferred_units
                         when User.units[:feet]
                           raw_distance.convert_to("mi")
                         when User.units[:meters]
                           raw_distance.convert_to("km")
                         end
    "#{converted_distance.scalar.to_f.round(1)} #{distance_units}"
  end

  # Converts a raw length to feet or meters depending on the current user.
  def formatted_elevation_gain(user = nil)
    preferred_units = user.nil? ?  User.units[:feet] : user.preferred_units
    length_units = user.nil? ?  "ft" : user.length_units
    raw_gain = Unit.new("#{elevation_gain} m")
    converted_gain = case preferred_units
                      when User.units[:feet]
                        raw_gain.convert_to("ft")
                      when User.units[:meters]
                        raw_gain
                      end
    "#{converted_gain.scalar.to_i} #{length_units}"
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
