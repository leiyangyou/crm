class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.references :type
      t.references :account
      t.date :start_date
      t.date :due_date
      t.integer :duration
      t.string :status
      t.references :consultant
      t.string :contract_id

      t.timestamps
    end
    add_index :memberships, :account_id
    add_index :memberships, :consultant_id
    add_index :memberships, :contract_id
    add_index :memberships, :type_id
  end
end
