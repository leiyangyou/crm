class UserRank < ActiveRecord::Base
  self.inheritance_column = nil
  belongs_to :user
  attr_accessible :rank_override
  has_paper_trail
end
