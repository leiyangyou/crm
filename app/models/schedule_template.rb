require 'schedule_template_decorator/template'
module ScheduleTemplateDecorator
end
class ScheduleTemplate < ActiveRecord::Base
  include ScheduleTemplateDecorator
  attr_accessible :parameters, :template_type, :is_default

  # to make sure there is only one default template
  after_save do
    if self.is_default
      ScheduleTemplate.find_all_by_is_default(true).each do |template|
        if template != self
          template.update_attributes(:is_default => false)
          template.save
        end
      end
    end
  end

  def schedule_for(date)
    template = Template.template_for self.template_type
    template = Template::DefaultTemplate unless template
    template.new(self.parameters).schedule_for(date)
  end

  def self.default
    ScheduleTemplate.find_by_is_default(true) || create_default_template
  end

  private
  def self.create_default_template
    template = ScheduleTemplate.new(:template_type => 'default', :parameters => '{}', :is_default => true)
    template.save
    template
  end
end
