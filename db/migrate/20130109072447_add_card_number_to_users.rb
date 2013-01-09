class AddCardNumberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :card_number, :string

    add_index :users, [:card_number], :unique => true
  end
end
