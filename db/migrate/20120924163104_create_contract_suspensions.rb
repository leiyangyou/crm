class CreateContractSuspensions < ActiveRecord::Migration
  def change
    create_table :contract_suspensions do |t|
      t.references :contract
      t.text :reason
      t.references :new_contract

      t.timestamps
    end
    add_index :contract_suspensions, :contract_id
    add_index :contract_suspensions, :new_contract_id
  end
end
