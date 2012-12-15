class AddPriceToMembershipTypes < ActiveRecord::Migration
  def change
    add_column :membership_types, :price, :integer, :default => 0
  end
end
