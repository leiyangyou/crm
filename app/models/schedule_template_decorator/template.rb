module ScheduleTemplateDecorator
  module Template
    @@classes = [] #classes inherited from Template::Base
    @@types = []
    @@templates = {} #template for a specified type
    def self.add(klass)
      @@classes << klass
    end

    def self.template_for(type)
      @@templates[type] ||= @@classes.first{|klass| klass.type} || DefaultTemplate
    end

    def self.types
      @@types ||= @@classes.map{|klass| klass.type}
    end

    class DefaultCodec
      include Singleton
      def dump parameters
        (parameters || {}).to_json
      end
      def load string
        JSON.parse(string)
      end
    end

    module ClassMethods
      def type type = nil
        if type
          @type = type
        else
          @type
        end
      end
      def codec codec = nil
        if codec
          raise 'codec must respond to load & dump' unless [:load, :dump].all?{|method| codec.respond_to? :method}
          @codec = codec
        else
          @codec ||= DefaultCodec.instance
        end
      end
    end

    class Base
      extend ClassMethods
      def self.inherited(child)
        Template.add(child)
      end
      attr_reader :parameters
      def initialize(parameters)
        @parameters = self.class.codec.load(parameters)
      end
    end
    class DefaultTemplate < Base
      type 'default'
      def schedule_for(date)
        daily_schedule = DailySchedule.new
        daily_schedule.working_time = DailySchedule::Utils.compact "8:00-16:00"
        daily_schedule.date = date
        daily_schedule
      end
    end
    #
    # parameters = {
    #   'working_time': [ working_time[, working_time...] ]
    # }
    class DailyTemplate < Base
      type 'daily'
      def schedule_for(date)
        daily_schedule = DailySchedule.new
        daily_schedule.working_time = DailySchedule::Utils.compact(*@parameters['working_time'])
        daily_schedule.date = date
      end
    end
    #
    # parameters = {
    #   'working_time': {
    #     '0': [ working_time[, working_time...]], //sunday
    #     '1': [ working_time[, working_time...]]
    #     ...
    #   }
    # }
    class WeeklyTemplate < Base
      type 'weekly'
      def schedule_for(date)
        daily_schedule = DailySchedule.new
        daily_schedule.working_time = DailySchedule::Utils.compact(*@parameters['working_time'][date.wday.to_s])
        daily_schedule.date = date
      end
    end
  end
end