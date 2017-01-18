module ActivitiesHelper
  # Returns the URL of the corresponding activity on Strava.
  def strava_activity_url(activity_id)
    "https://www.strava.com/activities/#{activity_id}"
  end

  # Returns an image tag for an icon representing either a sport or a meal.
  def icon_for(subject)
    image_tag("#{subject}.png", alt: subject, class: "icon #{subject}-icon")
  end
end
