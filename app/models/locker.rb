class Locker < ActiveRecord::Base
  attr_accessible :identifier
  validates_uniqueness :identifier
end
