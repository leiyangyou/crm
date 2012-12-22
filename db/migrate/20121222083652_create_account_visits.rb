class CreateAccountVisits < ActiveRecord::Migration
  def change
    create_table :account_visits do |t|
      t.references :account

      t.timestamps
    end
    add_index :account_visits, :account_id
  end
end
