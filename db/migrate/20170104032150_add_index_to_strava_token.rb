class AddIndexToStravaToken < ActiveRecord::Migration[5.0]
  def change
    add_index :users, :strava_token
  end
end
