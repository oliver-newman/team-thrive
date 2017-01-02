class RenamePreferredUnitsToPreferredUnit < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :preferred_units, :preferred_unit
  end
end
