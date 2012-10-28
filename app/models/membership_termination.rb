class MembershipTermination < ActiveRecord::Base
  belongs_to :membership
  belongs_to :contract
  attr_accessible :reason, :refund
end
