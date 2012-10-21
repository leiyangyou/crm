class LockerRental < ActiveRecord::Base
  belongs_to :locker
  belongs_to :account
  attr_accessible :due_date, :start_date
end
