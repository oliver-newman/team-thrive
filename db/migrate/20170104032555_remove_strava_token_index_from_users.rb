class RemoveStravaTokenIndexFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_index :users, :strava_token
  end
end
