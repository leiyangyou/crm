class AddUniqIndexOnAccountsCardNumber < ActiveRecord::Migration
  def up
    remove_index :accounts, :card_number
    add_index :accounts, :card_number, :unique => true
  end

  def down
    remove_index :accounts, :card_number
    add_index :accounts, :card_number
  end
end
