class SetDefaultUnitsToFeet < ActiveRecord::Migration[5.0]
  def change
    change_column_default :users, :preferred_units, "feet"
  end
end
