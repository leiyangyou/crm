class AddTrainerIdToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :trainer_id, :integer
  end
end
