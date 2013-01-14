class AddStartedOnAndFinishedOnToMembershipStates < ActiveRecord::Migration
  def change
    add_column :membership_states, :started_on, :date
    add_column :membership_states, :finished_on, :date
  end
end
