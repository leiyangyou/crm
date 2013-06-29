class AccountSurvey < ActiveRecord::Base
  belongs_to :respondent, :polymorphic => true
  belongs_to :survey
  belongs_to :response_set
  # attr_accessible :title, :body
end
