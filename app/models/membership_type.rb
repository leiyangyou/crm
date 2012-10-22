class MembershipType < ActiveRecord::Base
  attr_accessible :duration, :name, :transferable, :suspendable, :terminatable
  has_many :memberships, :foreign_key => "type_id"

end
