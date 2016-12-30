class ChangeActivitySportTypeToEnum < ActiveRecord::Migration[5.0]
  def change
    change_column :activities, :sport, :integer, default: 0
  end
end
