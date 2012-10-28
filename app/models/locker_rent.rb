class LockerRent < ActiveRecord::Base
  belongs_to :locker
  belongs_to :account
  attr_accessible :due_date, :start_date, :account_id, :contract_id

  def overdue?
    due_date < Date.today
  end
end
