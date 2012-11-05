class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.references :user
      t.references :template

      t.timestamps
    end
    add_index :schedules, :user_id
    add_index :schedules, :template_id
  end
end
