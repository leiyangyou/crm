class CreateUserDailyPerformances < ActiveRecord::Migration
  def change
    create_table :user_daily_performances do |t|
      t.time :date
      t.references :user
      t.integer :performance

      t.timestamps
    end
    add_index :user_daily_performances, :user_id
  end
end
