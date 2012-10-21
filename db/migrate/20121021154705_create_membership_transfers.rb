class CreateMembershipTransfers < ActiveRecord::Migration
  def change
    create_table :membership_transfers do |t|
      t.references :from_membership
      t.references :to_membership
      t.references :contract

      t.timestamps
    end
    add_index :membership_transfers, :from_membership_id
    add_index :membership_transfers, :to_membership_id
    add_index :membership_transfers, :contract_id
  end
end
