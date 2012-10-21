class MembershipType < ActiveRecord::Base
  attr_accessible :duration, :name
  has_many :memberships
end
