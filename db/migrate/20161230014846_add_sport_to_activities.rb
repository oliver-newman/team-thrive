class AddSportToActivities < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :sport, :string
  end
end
