class CreateUserRanks < ActiveRecord::Migration
  def change
    create_table :user_ranks do |t|
      t.references :user
      t.integer :rank, :default => 99999

      t.timestamps
    end
    add_index :user_ranks, :user_id, :unique => true
  end
end
