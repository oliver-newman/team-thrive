class RenamePreferredUnitToUnitPreference < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :preferred_unit, :unit_preference
  end
end
