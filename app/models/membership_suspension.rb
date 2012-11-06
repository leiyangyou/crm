class MembershipSuspension < ActiveRecord::Base
  belongs_to :membership
  attr_accessible :contract_id, :due_date, :start_date
  validates_presence_of :membership_id

  def self.create( membership, params)
    suspension = MembershipSuspension.new(params)
    suspension.membership = membership
  end
end
