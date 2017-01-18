# Functions related to polyline maps.

module PolylineMapsHelper
  # Returns the URL for the Google Maps static map image showing an activity
  # polyline.
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
    image_tag(polyline_map_url(polyline, size, color),
              alt: "Activity map")
  end
end
