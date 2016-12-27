class CreateActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
      t.string :sport
      t.datetime :start_date
      t.float :distance
      t.float :elevation_gain
      t.integer :moving_time
      t.string :title
      t.text :comments
      t.integer :strava_activity_id
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :activities, [:user_id, :start_date]
  end
end
