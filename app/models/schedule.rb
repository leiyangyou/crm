class Schedule < ActiveRecord::Base
  belongs_to :user
  has_many :slots
  attr_accessible :date

  scope :for_date, lambda{|date| where(:date => date)}

  def available? time
    slots.select{|slot| slot.available?(time)}.size > 0
  end
end
