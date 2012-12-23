class AccountSurvey < ActiveRecord::Base
  belongs_to :account
  belongs_to :survey
  belongs_to :response_set
  # attr_accessible :title, :body

  validates_uniqueness_of :survey_id, :scope => :account_id
end
