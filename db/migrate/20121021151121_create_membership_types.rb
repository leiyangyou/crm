class CreateMembershipTypes < ActiveRecord::Migration
  def change
    create_table :membership_types do |t|
      t.string :name
      t.integer :duration
      t.boolean :transferable, :default => true
      t.boolean :suspendable, :default => true
      t.boolean :terminatable, :default => true
      t.timestamps
    end
  end
end
