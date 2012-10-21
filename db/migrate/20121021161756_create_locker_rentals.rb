class CreateLockerRentals < ActiveRecord::Migration
  def change
    create_table :locker_rentals do |t|
      t.references :locker
      t.references :account
      t.date :start_date
      t.date :due_date

      t.timestamps
    end
    add_index :locker_rentals, :locker_id
    add_index :locker_rentals, :account_id
  end
end
