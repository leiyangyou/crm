class Schedule < ActiveRecord::Base
  belongs_to :user
  belongs_to :template, :class_name => "ScheduleTemplate"
  has_many :daily_schedules

  FIRST_DAY_OF_WEEK = :monday unless defined? FIRST_DAY_OF_WEEK

  def schedule_for( date)
    daily_schedule = self.daily_schedules.find_by_date( date)
    unless daily_schedule
      template = self.template || ScheduleTemplate.default
      daily_schedule = template.schedule_for( date)
      daily_schedule.schedule = self
    end
    daily_schedule
  end

  def schedule_for_today
    self.schedule_for Date.today
  end

  def weekly_schedules(date)
    date = date.beginning_of_week(FIRST_DAY_OF_WEEK)
    (0..6).map do |delta|
      schedule_for( date + delta)
    end
  end
end
