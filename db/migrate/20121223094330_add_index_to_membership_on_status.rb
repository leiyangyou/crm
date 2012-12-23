class AddIndexToMembershipOnStatus < ActiveRecord::Migration
  def change
    add_index :memberships, [:status]
  end
end
