class AddPerformanceAndRankTypes < ActiveRecord::Migration
  def change
    add_column :user_daily_performances, :type, :string
    add_index :user_daily_performances, :type

    add_column :user_ranks, :type, :string
    add_index :user_ranks, :type
  end
end
