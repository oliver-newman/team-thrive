# Users
User.create!(first_name: "Oliver",
             last_name: "Newman",
             email: "oliver@whmsi.com",
             strava_id: 5882007,
             password:  "password",
             password_confirmation: "password",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

User.create!(first_name: "Example",
             last_name: "User",
             email: "user@example.com",
             strava_id: 5882007,
             password:  "password",
             password_confirmation: "password",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

99.times do |i|
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  email = "#{first_name.downcase}#{i+1}@example.com"
  strava_id = 5882007
  password = "password"
  User.create!(first_name: first_name,
               last_name: last_name,
               email: email,
               strava_id: strava_id,
               password: password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end


# Activities
users = User.order(:created_at).take(6)
50.times do
  users.each do |user|
    user.activities.create!(title: Faker::Lorem.sentence, 
                            sport: 'run',
                            start_date: Faker::Date.between(10.years.ago,
                                                            Time.zone.now))
  end
end
