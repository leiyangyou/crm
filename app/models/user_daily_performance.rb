class UserDailyPerformance < ActiveRecord::Base
  belongs_to :user
  attr_accessible :date, :performance
end
