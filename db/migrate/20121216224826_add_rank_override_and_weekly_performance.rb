class AddRankOverrideAndWeeklyPerformance < ActiveRecord::Migration
  def change
    add_column :user_ranks, :rank_override, :integer
    add_column :user_ranks, :weekly_performance, :integer
  end
end
