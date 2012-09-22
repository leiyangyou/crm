class ScheduleTemplate < ActiveRecord::Base
  belongs_to :parent, :class_name => "ScheduleTemplate"
  attr_accessible :attributes, :template
  has_many :children, :class_name => "ScheduleTemplate", :primary_key => :parent_id

  serialize :attributes, Hash

  serialize :template, Template

  class << self
    def has_attribute(attributes)
      self.all.select do |schedule|
        schedule.valid_for_attributes?( attributes)
      end
    end

    def default
      default_attributes = AttributesBuilder.new.default.build
      self.has_attribute(default_attributes).first || ScheduleTemplate.create(:attributes => default_attributes)
    end
  end

  def inherit_template
    if parent
      template.merge( parent.inherit_template)
    else
      template
    end
  end

  def apply_to(user, any_day_of_the_week)
    any_day_of_the_week = any_day_of_the_week.to_date
    schedules = []
    ScheduleTemplate::Template::DAYNAMES.each do |day_name|
      day_of_week = any_day_of_the_week.send(:day_name.downcase)
      schedule = user.schedules.for_date( day_of_week)
      schedule = Schedule.new(:user => user, :date => day_of_week) unless schedule
      schedules << schedule
      self.inherit_template.schedule.fetch(day_name, []).each do |slots|
        slots.each do |slot|
          schedule.slots.create(:begin_time => slot.begin_time, :end_time => slot.end_time)
        end
      end
    end
    schedules
  end

  protected
  def valid_for_attributes?( attributes)
    attributes.select{|k,v| self.attributes[k] != v}.size == 0
  end
end
