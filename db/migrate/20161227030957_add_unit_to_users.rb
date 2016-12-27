class AddUnitToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :unit, :string
  end
end
