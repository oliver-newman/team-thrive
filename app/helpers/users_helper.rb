module UsersHelper
  def gravatar_for(user, size: 80)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.first_name, class: "gravatar")
  end

  def strava_stats_for(user)
    if user.strava_id
      @client = Strava::Api::V3::Client.new(
        access_token: '1deb258a0ea31a3e65f19d2ca3307c8411dcd949')
      @client.totals_and_stats(user.strava_id)
    end
  end
end
