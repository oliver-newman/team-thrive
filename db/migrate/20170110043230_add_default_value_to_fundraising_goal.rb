class AddDefaultValueToFundraisingGoal < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :fundraising_goal, :float, default: 100
  end
end
