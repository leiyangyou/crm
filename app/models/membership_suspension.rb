class MembershipSuspension < ActiveRecord::Base
  belongs_to :membership
  belongs_to :contract
  validates_presence_of :membership_id

  def self.create( membership, params)
    suspension = MembershipSuspension.new(params)
    suspension.membership = membership
  end
end
