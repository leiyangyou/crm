class ScheduleTemplate::Template
  attr_accessor :schedule

  DAYNAMES = Date::DAYNAMES

  class Slot
    attr_accessor :begin_time, :end_time

    def intersect? other_slot
      other_slot.end_time > begin_time && other_slot.begin_time < end_time
    end
  end

  class ConflictSlotException < Exception
  end

  def initialize
    self.schedule = {}
    DAYNAMES.each do |name|
      schedule[name] = []
    end
  end

  def add_slot(day_name, new_slot)
    return unless valid_name?(dayname)
    schedule[day_name].each do |slot|
      raise ConflictSlotException if slot.intersect? new_slot
    end
    schedule[day_name] << slot
  end

  def merge( template)
    new_schedule = {}
    schedule.each do |day_name, value|
      if schedule[day_name].empty?
        new_schedule[day_name] = template.schedule[day_name]
      else
        new_schedule[day_name] = value
      end
    end
    self.schedule = new_schedule
  end

  protected
  def valid_name? name
    DAYNAMES.include? name
  end
end