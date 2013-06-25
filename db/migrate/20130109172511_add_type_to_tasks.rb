class AddTypeToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :related_to_trainer, :boolean
    add_index :tasks, [:related_to_trainer]
    add_column :tasks, :related_to_consultant, :boolean
    add_index :tasks, [:related_to_consultant]
  end
end
