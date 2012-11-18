class CreateMembershipStates < ActiveRecord::Migration
  def change
    create_table :membership_states do |t|
      t.string :state_type
      t.string :contract_id
      t.references :last_state
      t.references :membership
      t.text :parameters

      t.timestamps
    end
    add_index :membership_states, :last_state_id
    add_index :membership_states, :membership_id
  end
end
