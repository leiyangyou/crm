class MembershipTransfer < ActiveRecord::Base
  belongs_to :from_membership, :class_name => 'Membership', :foreign_key => :from_membership_id
  belongs_to :to_membership, :class_name => 'Membership', :foreign_key => :to_membership_id
  attr_accessible :to_membership_id, :contract_id
end
