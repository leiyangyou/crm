class CreateSlots < ActiveRecord::Migration
  def change
    create_table :slots do |t|
      t.references :schedule
      t.integer :start_time
      t.integer :end_time

      t.timestamps
    end
    add_index :slots, :schedule_id
  end
end
