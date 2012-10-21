class Locker < ActiveRecord::Base
  belongs_to :account
  belongs_to :contract
  attr_accessible :due_date, :start_date, :string
end
