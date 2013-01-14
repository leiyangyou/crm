class AddCurrentStateIdToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :current_state_id, :integer
  end
end
