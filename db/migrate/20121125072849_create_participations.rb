class CreateParticipations < ActiveRecord::Migration
  def change
    create_table :participations do |t|
      t.references :account
      t.references :lesson
      t.references :trainer
      t.integer :times

      t.timestamps
    end
    add_index :participations, :account_id
    add_index :participations, :lesson_id
    add_index :participations, :trainer_id
  end
end
