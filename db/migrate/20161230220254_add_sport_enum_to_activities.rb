class AddSportEnumToActivities < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :sport, :integer
  end
end
