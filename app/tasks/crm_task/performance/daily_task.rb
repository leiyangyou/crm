module CRMTask
  module Performance
    class DailyTask < ::CRMTask::Base
      def perform *args
        options = args.extract_options!
        date = extract_date_from_options options
        date = date.beginning_of_day

        [:trainer, :consultant].each do |role|
          User.with_any_role(role).find_each do |user|
            UserDailyPerformance.find_or_create_by_user_id_and_date_and_type(
              user.id,
              date,
              role.to_s
            ).update_attributes!(
              {:performance => (user.send :"#{role}_performance", :since => date, :til => date + 1.day)},
               :without_protection => true
            )
          end
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