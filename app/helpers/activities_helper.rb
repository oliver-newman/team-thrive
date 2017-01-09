module ActivitiesHelper
  # Returns the URL of the corresponding activity on Strava.
  def strava_activity_url(activity_id)
    "https://www.strava.com/activities/#{activity_id}"
  end

  # Returns an image tag for an icon representing either a sport or a meal
  def icon_for(subject)
    image_tag("#{subject}.png", alt: subject, class: "icon #{subject}-icon")
  end

  def polyline_image(polyline, size)
    polyline = CGI::escape(polyline.to_s) # CGI::escape(polyline.to_s)
    p polyline
    image_tag("https://maps.googleapis.com/maps/api/staticmap?" +
                "size=#{size}x#{size}" +
                "&path=weight:3%color:orange%7:Cenc:#{polyline}" +
                "&key=#{Rails.application.secrets.GOOGLE_MAPS_KEY}",
              alt: "Activity map")
  end
end
