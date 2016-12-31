class ChangePreferredUnitsToEnum < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :preferred_units
    add_column :users, :preferred_units, :integer
  end
end
