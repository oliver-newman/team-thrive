class ChangeActivitySportTypeToEnum < ActiveRecord::Migration[5.0]
  def change
    change_column :activities, :sport, 'integer USING CAST(sport AS integer)'
  end
end
