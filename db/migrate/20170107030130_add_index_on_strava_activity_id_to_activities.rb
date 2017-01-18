class AddIndexOnStravaActivityIdToActivities < ActiveRecord::Migration[5.0]
  def change
    add_index :activities, :strava_activity_id, unique: true
  end
end
