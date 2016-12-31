class MakeFeetDefaultUnits < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :preferred_units, :integer, default: 0
  end
end
