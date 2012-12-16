class UserRank < ActiveRecord::Base
  belongs_to :user
  attr_accessible :rank
end
