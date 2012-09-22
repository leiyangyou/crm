class CreateScheduleTemplates < ActiveRecord::Migration
  def change
    create_table :schedule_templates do |t|
      t.text :template
      t.text :attributes
      t.references :parent

      t.timestamps
    end
    add_index :schedule_templates, :parent_id
  end
end
