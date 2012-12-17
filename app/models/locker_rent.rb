class LockerRent < ActiveRecord::Base
  belongs_to :locker
  belongs_to :account
  attr_accessible :start_date, :due_date, :account_id, :contract_id

  def overdue?
    due_date < Date.today
  end

  def self.from_contract contract
    locker = contract.locker
    account = contract.account
    locker_rent = LockerRender.new
    locker_rent.start_date = contract.start_date
    locker_rent.due_date = contract.due_date
    locker_rent.locker = locker
    locker_rent.account = account
  end
end
