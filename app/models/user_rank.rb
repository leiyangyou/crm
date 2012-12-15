class UserRank < ActiveRecord::Base
  belongs_to :user
  attr_accessible :order
end
