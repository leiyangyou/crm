class ScheduleTemplate::Template
  attr_accessor :schedule

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
    7.times do |i|
      schedule[i] = []
    end
  end

  def add_slot(day_of_week, new_slot)
    return unless valid_key?(day_of_week)
    schedule[day_of_week].each do |slot|
      raise ConflictSlotException if slot.intersect? new_slot
    end
    schedule[day_of_week] << slot
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

  protected
  def valid_key? key
    (0..6).include?(key)
  end
end