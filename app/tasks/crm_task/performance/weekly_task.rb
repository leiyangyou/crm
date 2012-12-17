module CRMTask
  module Performance
    class WeeklyTask < ::CRMTask::Base
      def perform *args
        options = args.extract_options!
        date = extract_date_from_options options
        date = date.beginning_of_week

        PaperTrail.whodunnit = User.admins.first.id

        weekly_performances =  UserDailyPerformance.weekly_performances(date)

        [:trainer, :consultant].each do |role|
          weekly_performances.
            where(:type => role.to_s).
            sum(:performance, :group => :user_id).sort_by {|k,v| v}.
            reverse_each.each_with_index do |performance, index|
            UserRank.find_or_create_by_user_id_and_type(performance[0], role.to_s).update_attributes!(
              {:rank => index,
              :rank_override => index,
              :weekly_performance => performance[1]},
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