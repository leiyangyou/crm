class AddFutureStateToMembershipStates < ActiveRecord::Migration
  def change
    add_column :membership_states, :future_state_id, :integer

    add_index :membership_states, [:future_state_id]
  end
end
