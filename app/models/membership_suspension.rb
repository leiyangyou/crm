class MembershipSuspension < ActiveRecord::Base
  belongs_to :membership
  belongs_to :contract
  # attr_accessible :title, :body
end
