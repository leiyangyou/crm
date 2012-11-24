class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.references :type
      t.references :account
      t.date :started_on
      t.date :finished_on
      t.integer :duration, :default => 0
      t.string :status
      t.string :contract_id
      t.references :consultant

      t.timestamps
    end
    add_index :memberships, :account_id
    add_index :memberships, :consultant_id
    add_index :memberships, :type_id
  end
end
