class Locker < ActiveRecord::Base
  attr_accessible :identifier
  validates_uniqueness :identifier
  state_machine :status, :initial => :free do
    event :rent do
      transition :free => :occupied
    end

    event :return do
      transition :occupied => :free
    end
  end
end
