# Users
99.times do |i|
  User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    unit_preference: feet
    fundraising_goal: 1000
    email: "user#{i+1}@example.com",
    strava_token: Faker::Crypto.sha1,
    strava_id: i
  )
end


# Activities
users = User.order(:created_at).take(6)
50.times do |i|
  users.each_with_index do |user, j|
    user.activities.create!(
      title: Faker::Lorem.sentence[0..-2], 
      sport: ["run", "ride"].sample,
      distance: rand(10000),
      elevation_gain: rand(1000),
      moving_time: rand(10000),
      strava_activity_id: i + j
      start_date: Faker::Date.between(5.years.ago, Time.zone.now)
    )
  end
end


# Following relationships
users = User.all
user = users.first
following  = users[2..50]
followers  = users[3..70]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

