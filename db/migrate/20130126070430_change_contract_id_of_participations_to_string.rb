class ChangeContractIdOfParticipationsToString < ActiveRecord::Migration
  def change
    change_column :participations, :contract_id, :string
  end
end
