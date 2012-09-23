class Schedule < ActiveRecord::Base
  belongs_to :user
  has_many :slots
  attr_accessible :date
  validates_with Validators::SlotsConflictValidator

  scope :for_date, lambda{|date| where(:date => date)}

  def available? time
    slots.select{|slot| slot.available?(time)}.size > 0
  end

  def slots_group_by_date
    slots.group_by{|slot| slot.date.strftime "%Y-%m-%d"}
  end
end
