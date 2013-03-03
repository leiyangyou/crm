class AddStatusToParticipation < ActiveRecord::Migration
  def change
    add_column :participations, :status, :string
    add_index :participations, [:status]
  end
end
