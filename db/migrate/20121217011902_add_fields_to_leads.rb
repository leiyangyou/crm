class AddFieldsToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :gender, :integer
  end
end
