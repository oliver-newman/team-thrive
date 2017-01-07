module ActivitiesHelper
  # Converts a raw distance (in meters) to miles or km depending on the
  # unit preference of user (defaults to miles), and formats as a string with
  # units.
  def distance_formatted_for(distance, user = nil)
    raw_distance = Unit.new("#{distance} m")
    distance_unit = user.nil? ? "mi" : user.distance_unit

    converted_distance = raw_distance.convert_to(distance_unit)
    converted_distance.round(1)
  end

  # Converts a raw elevation gain (in meters) to feet or meters depending on
  # the unit preference of user (defaults to feet), and formats as a
  # string with units.
  def elevation_gain_formatted_for(elevation_gain, user = nil)
    raw_gain = Unit.new("#{elevation_gain} m")
    length_unit = user.nil? ?  "ft" : user.length_unit

    converted_gain = raw_gain.convert_to(length_unit)
    converted_gain.round(0)
  end

  def moving_time_formatted(moving_time)
    formatted_time(moving_time)
  end

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

  # Returns the URL of the corresponding activity on Strava.
  def strava_activity_url(activity_id)
    "https://www.strava.com/activities/#{activity_id}"
  end

  def map_url(polyline, size)
    "https://maps.googleapis.com/maps/api/staticmap?size=#{size}x#{size}" +
      "&path=weight:3%color:orange%7:Cenc:#{CGI.escape(polyline.to_s)}" +
      "&key=#{Rails.application.secrets.GOOGLE_MAPS_KEY}"
  end
end
