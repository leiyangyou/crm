class AddMcModifiedAtToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :mc_modified_at, :datetime
    add_index :leads, [:mc_modified_at]
  end
end
