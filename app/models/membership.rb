class Membership < ActiveRecord::Base
  belongs_to :account
  belongs_to :consultant, :class_name => 'User'
  belongs_to :contract
  belongs_to :type, :class_name => "MembershipType", :foreign_key => "type_id"
  attr_accessible :due_date, :duration
end
