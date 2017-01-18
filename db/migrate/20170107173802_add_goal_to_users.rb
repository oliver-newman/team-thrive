class AddGoalToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :fundraising_goal, :float
  end
end
