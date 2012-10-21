class Membership < ActiveRecord::Base
  belongs_to :account
  belongs_to :consultant
  belongs_to :contract
  attr_accessible :due_date, :duration, :type
end
