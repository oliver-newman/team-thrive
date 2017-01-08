module ActivitiesHelper
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
