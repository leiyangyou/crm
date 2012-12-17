class CreateLockerRents < ActiveRecord::Migration
  def change
    create_table :locker_rents do |t|
      t.references :locker
      t.references :account
      t.string :contract_id
      t.date :started_on
      t.date :finished_on

      t.timestamps
    end
    add_index :locker_rents, :locker_id
    add_index :locker_rents, :account_id
  end
end
