class CreateContractTrasfers < ActiveRecord::Migration
  def change
    create_table :contract_trasfers do |t|
      t.references :contract
      t.references :new_contract

      t.timestamps
    end
    add_index :contract_trasfers, :contract_id
    add_index :contract_trasfers, :new_contract_id
  end
end
