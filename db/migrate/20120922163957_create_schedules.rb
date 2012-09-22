class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.references :user
      t.date :date

      t.timestamps
    end
    add_index :schedules, :user_id
  end
end
