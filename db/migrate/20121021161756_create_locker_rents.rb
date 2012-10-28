class CreateLockerRents < ActiveRecord::Migration
  def change
    create_table :locker_rents do |t|
      t.references :locker
      t.references :account
      t.date :start_date
      t.date :due_date

      t.timestamps
    end
    add_index :locker_rents, :locker_id
    add_index :locker_rents, :account_id
  end
end
