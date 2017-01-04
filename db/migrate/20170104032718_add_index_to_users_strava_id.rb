class AddIndexToUsersStravaId < ActiveRecord::Migration[5.0]
  def change
    add_index :users, :strava_id, unique: true
  end
end
