class Locker < ActiveRecord::Base
  has_one :locker_rent
  attr_accessible :identifier
  validates_uniqueness_of :identifier

  sortable :by => ["identifier ASC"]
  state_machine :status, :initial => :available do
    event :rent do
      transition :available => :occupied
    end

    event :restore do
      transition :occupied => :available
    end
  end

  scope :available, lambda {
    where(:status => "available")
  }

  delegate :overdue?, :to => :locker_rent, :allow_nil => true

end
