class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.string :name
      t.text :description
      t.integer :times
      t.integer :price

      t.timestamps
    end
  end
end
