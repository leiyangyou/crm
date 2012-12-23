class CreateAccountSurveys < ActiveRecord::Migration
  def change
    create_table :account_surveys do |t|
      t.references :account
      t.references :survey
      t.references :response_set

      t.timestamps
    end
    add_index :account_surveys, :account_id
    add_index :account_surveys, :survey_id
    add_index :account_surveys, :response_set_id
    add_index :account_surveys, [:account_id, :survey_id], :unique => true
  end
end
