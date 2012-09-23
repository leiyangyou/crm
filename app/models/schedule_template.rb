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

end
