class CreateMembershipSuspensions < ActiveRecord::Migration
  def change
    create_table :membership_suspensions do |t|
      t.references :membership
      t.references :contract

      t.timestamps
    end
    add_index :membership_suspensions, :membership_id
    add_index :membership_suspensions, :contract_id
  end
end
