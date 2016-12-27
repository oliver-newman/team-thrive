class CreateActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
      t.string :type
      t.datetime :start_date
      t.float :distance
      t.float :elevation_gain
      t.integer :moving_time
      t.string :title
      t.text :comments
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :microposts, [:user_id, :start_date]
  end
end
