class AddStravaAccessTokenToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :strava_token, :string
  end
end
