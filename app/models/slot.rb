class Slot < ActiveRecord::Base
  belongs_to :schedule

  attr_accessible :end_time, :start_time

  validates :start_time, :end_time, :numericality => true, :presence => true, :inclusion => { :in => 0..86400}

  validates_with Validators::TimeValidator


  def available? time
    (start_time..end_time).include? time.seconds_since_midnight
  end
end