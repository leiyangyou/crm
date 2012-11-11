class CreateMembershipTerminations < ActiveRecord::Migration
  def change
    create_table :membership_terminations do |t|
      t.references :membership
      t.string :contract_id
      t.string :reason
      t.integer :refund

      t.timestamps
    end
    add_index :membership_terminations, :membership_id
    add_index :membership_terminations, :contract_id
  end
end
