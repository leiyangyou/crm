class AddLeadIdToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :lead_id, :integer
    add_index :accounts, :lead_id
  end
end
