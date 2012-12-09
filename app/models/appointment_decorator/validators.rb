module AppointmentDecorator
  module Validators
    class TimeValidator <ActiveModel::Validator
      def validate(record)
        daily_schedule = record.daily_schedule
        time_range = DailySchedule::TimeRange.new record.started_at, record.finished_at
        unless daily_schedule.working?(time_range)
          record.errors.add( :base, :"user.error.not_working", :time => time_range.to_s)
        end
        unless daily_schedule.available?(time_range)
          record.errors.add( :base, :"user.error.unavailable", :time => time_range.to_s)
        end
      end
    end
  end
end