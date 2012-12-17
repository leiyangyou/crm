class UserDailyPerformance < ActiveRecord::Base
  self.inheritance_column = nil
  belongs_to :user
  scope :weekly_performances, lambda { |date|
    where(:created_at => (date..date + 1.week))
  }
end
