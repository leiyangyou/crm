class ScheduleTemplate
  attr_accessor :template

  class << self
    def default
      return @default_template if @default_template
      @default_template = Tempalte.new
      now = Time.now
      slot = Template::Slot.new(
          :begin_time => Time.parse("8:00", now).seconds_since_midnight,
          :end_time => Time.parse("17:00", now).seconds_since_midnight)
      7.times do |i|
        @default_template.add_slot(i, slot)
      end
    end
  end

  def apply_to(user, any_day_of_the_week)
    any_day_of_the_week = any_day_of_the_week.to_date
    beginning_of_week = any_day_of_the_week.jewish_beginning_of_week
    end_of_week = any_day_of_the_week.jewish_end_of_week
    schedule = user.schedules.for_date( beginning_of_week)
    schedule = Schedule.new(:user => user, :date => day_of_week) unless schedule
    (beginning_of_week..end_of_week).each do |date_of_week|
      self.template.schedule.fetch(date_of_week.wday, []).each do |slots|
        slots.each do |slot|
          schedule.slots.build(:date => date_of_week, :begin_time => slot.begin_time, :end_time => slot.end_time)
        end
      end
    end
    schedule
  end

end
