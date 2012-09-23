class ScheduleTemplate::Template
  attr_accessor :schedule

  class Slot
    attr_accessor :begin_time, :end_time

    def intersects_with? other_slot
      other_slot.end_time > begin_time && other_slot.begin_time < end_time
    end
  end

  class ConflictSlotException < Exception
  end

  def initialize
    self.schedule = {}
    7.times do |i|
      schedule[i] = []
    end
  end

  def add_slot(day_of_week, new_slot)
    return unless valid_key?(day_of_week)
    schedule[day_of_week].each do |slot|
      raise ConflictSlotException if slot.intersects_with? new_slot
    end
    schedule[day_of_week] << new_slot
  end

  def merge( template)
    new_schedule = {}
    schedule.each do |key, value|
      if schedule[key].empty?
        new_schedule[key] = template.schedule[key]
      else
        new_schedule[key] = value
      end
    end
    self.schedule = new_schedule
  end

  def apply_to(user, any_day_of_the_week)
    any_day_of_the_week = any_day_of_the_week.to_date
    beginning_of_week = any_day_of_the_week.jewish_beginning_of_week
    end_of_week = any_day_of_the_week.jewish_end_of_week
    schedule = user.schedules.for_date( beginning_of_week)
    schedule = Schedule.new(:user => user, :date => day_of_week) unless schedule
    (beginning_of_week..end_of_week).each do |date_of_week|
      self.schedule.fetch(date_of_week.wday, []).each do |slots|
        slots.each do |slot|
          schedule.slots.build(:date => date_of_week, :begin_time => slot.begin_time, :end_time => slot.end_time)
        end
      end
    end
    schedule
  end

  protected
  def valid_key? key
    (0..6).include?(key)
  end
end