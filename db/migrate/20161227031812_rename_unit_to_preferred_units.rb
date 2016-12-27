class RenameUnitToPreferredUnits < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :unit, :preferred_units
  end
end
