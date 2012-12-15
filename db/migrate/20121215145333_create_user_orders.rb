class CreateUserOrders < ActiveRecord::Migration
  def change
    create_table :user_orders do |t|
      t.references :user
      t.integer :order, :default => 99999

      t.timestamps
    end
    add_index :user_orders, :user_id, :unique => true
  end
end
