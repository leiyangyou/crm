class AddContractIdToParticipation < ActiveRecord::Migration
  def change
    add_column :participations, :contract_id, :integer
  end
end
