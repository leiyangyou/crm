class CreateDailySchedules < ActiveRecord::Migration
  def change
    create_table :daily_schedules do |t|
      t.references :schedule
      t.date :date
      t.integer :slots, :limit => 8
      t.integer :working_time, :limit => 8

      t.timestamps
    end
    add_index :daily_schedules, :schedule_id
  end
end
