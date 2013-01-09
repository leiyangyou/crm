class LockerRent < ActiveRecord::Base
  belongs_to :locker
  belongs_to :account
  attr_accessible :started_on, :finished_on, :account_id, :contract_id

  def overdue?
    finished_on < Date.today
  end
end
