class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.references :daily_schedule
      t.date :date
      t.time :started_at
      t.time :finished_at
      t.string :status
      t.string :content

      t.timestamps
    end
    add_index :appointments, :daily_schedule_id
  end
end
