class CreateParticipationLogs < ActiveRecord::Migration
  def change
    create_table :participation_logs do |t|
      t.references :participation
      t.references :trainer
      t.references :lesson
      t.references :operator

      t.timestamps
    end
    add_index :participation_logs, :participation_id
    add_index :participation_logs, :trainer_id
    add_index :participation_logs, :lesson_id
    add_index :participation_logs, :operator_id
  end
end
