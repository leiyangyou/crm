class AlterAccountSurveyToPolymorphic < ActiveRecord::Migration
  def up
    add_column :account_surveys, :respondent_id, :integer
    add_column :account_surveys, :respondent_type, :string
    AccountSurvey.all.each do |account_survey|
      account_survey.respondent_type = Account.to_s
      account_survey.respondent_id = account_survey.account_id
      account_survey.save
    end
    remove_column :account_surveys, :account_id
    add_index :account_surveys, [:respondent_type, :respondent_id]
  end

  def down
    add_column :account_surveys, :account_id, :integer
    AccountSurvey.all.each do |account_survey|
      if account_survey.respondent_type != Account.to_s
        account_survey.delete
      else
        account_survey.account_id = account_survey.respondent_id
        account_survey.save
      end
    end
    remove_column :account_surveys, :respondent_id, :integer
    remove_column :account_surveys, :respondent_type, :string
    add_index :account_surveys, :account_id
  end
end
