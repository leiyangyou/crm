module CRMTask
  module Performance
    class DailyTask < ::CRMTask::Base
      def perform *args
        options = args.extract_options!
        date = extract_date_from_options options
        date = date.beginning_of_day
        User.find_each do |user|
          performance = user.performance :date => date
          daily_performance = UserDailyPerformance.new :date =>date, :performance =>performance
          daily_performance.user = user
          daily_performance.save
        end
      end

      private
      def extract_date_from_options options
        date = Date.today
        if options[:date]
          date = Date.parse(options[:date]) rescue Exception
        end
        date
      end
    end
  end
end