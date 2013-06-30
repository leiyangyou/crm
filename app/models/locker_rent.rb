class LockerRent < ActiveRecord::Base
  belongs_to :locker
  belongs_to :account
  attr_accessible :start_date, :due_date, :account_id, :contract_id

  delegate :identifier, :to => :locker

  validate :not_overdue_when_create, :on => :create

  def overdue?
    self.due_date <= Date.today
  end

  private
  def not_overdue_when_create
    errors.add(:due_date, :overdue_when_create) if self.overdue?
  end
end
