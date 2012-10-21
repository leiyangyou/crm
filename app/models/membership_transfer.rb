class MembershipTransfer < ActiveRecord::Base
  belongs_to :from_membership
  belongs_to :to_membership
  belongs_to :contract
  # attr_accessible :title, :body
end
