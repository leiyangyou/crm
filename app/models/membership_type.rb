class MembershipType < ActiveRecord::Base
  attr_accessible :duration, :name, :price, :transferable, :suspendable, :terminatable
  has_many :memberships, :foreign_key => "type_id"

end
