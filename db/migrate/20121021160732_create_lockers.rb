class CreateLockers < ActiveRecord::Migration
  def change
    create_table :lockers do |t|
      t.string :identifier
      t.references :account
      t.references :contract
      t.date :start_date
      t.date :due_date

      t.timestamps
    end
    add_index :lockers, :account_id
    add_index :lockers, :contract_id
  end
end
