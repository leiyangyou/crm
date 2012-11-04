class CreateScheduleTemplates < ActiveRecord::Migration
  def change
    create_table :schedule_templates do |t|
      t.string :template_type
      t.boolean :is_default
      t.text :parameters

      t.timestamps
    end
  end
end
