module AppointmentDecorator
end
class Appointment < ActiveRecord::Base
  belongs_to :daily_schedule
  attr_accessible :content, :date, :finished_at, :started_at, :status

  validates_presence_of :date, :started_at, :finished_at

  validates_with AppointmentDecorator::Validators::TimeValidator

  state_machine :status, :initial => :normal do
    event :cancel do
      transition :normal => :canceled
    end

    after_transition :to => :canceled do
      self.daily_schedule.cancel_appointment(self)
    end
  end

  def started_at= started_at
    self.raw_write_attribute(:started_at, convert_time(started_at))
  end

  def finished_at= finished_at
    self.raw_write_attribute(:finished_at, convert_time(finished_at))
  end

  def completed? at = Time.now
    at_date = at.to_date
    if self.date < at_date
      true
    elsif self.date > at_date
      false
    else
      self.finished_at.compare_time(at) <= 0
    end
  end

  def started? at = Time.now
    at_date = at.to_date
    if self.date < at_date
      true
    elsif self.date > at_date
      false
    else
      self.started_at.compare_time(at) <= 0
    end
  end

  private
  def convert_time time
    case time
      when String
        sections = time.split(":")
        today = Date.today
        Time.local( today.year, today.month, today.day, sections[0].to_i, sections[1].to_i)
      when Date
        time.to_time
      when Time
        time
      else
        nil
    end
  end

end
