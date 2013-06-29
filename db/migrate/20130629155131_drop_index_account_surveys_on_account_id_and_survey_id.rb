class DropIndexAccountSurveysOnAccountIdAndSurveyId < ActiveRecord::Migration
  def up
    remove_index :account_surveys, :column => [:account_id, :survey_id]
  end

  def down
    add_index :account_surveys, [:account_id, :survey_id], :unique => true
  end
end
