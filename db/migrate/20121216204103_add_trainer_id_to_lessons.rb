class AddTrainerIdToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :trainer_id, :integer
    add_index :lessons, :trainer_id
  end
end
