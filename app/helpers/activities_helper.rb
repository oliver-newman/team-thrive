module ActivitiesHelper
  # Returns the URL of the corresponding activity on Strava.
  def strava_activity_url(activity_id)
    "https://www.strava.com/activities/#{activity_id}"
  end

  # Returns an image tag for an icon representing either a sport or a meal.
  def icon_for(subject)
    image_tag("#{subject}.png", alt: subject, class: "icon #{subject}-icon")
  end

  def polyline_map_url(polyline, size, color)
    polyline = CGI::escape(polyline.to_s)
    "https://maps.googleapis.com/maps/api/staticmap?" +
      "size=#{size}x#{size}" + 
      "&path=weight:3%7Ccolor:#{color}%7Cenc:#{polyline}" +
      "&key=#{Rails.application.secrets.GOOGLE_MAPS_KEY}"
  end

  # Returns an image tag for a Google Maps image with the GPS polyline of the
  # activity.
  def polyline_image(polyline, size = 150, color = "blue")
    image_tag(polyline_map_url(polyline, size: size, color: color),
              alt: "Activity map")
  end
end
