module Admin::SchedulesHelper
  def time_to_s(time)
    Time.at(Time.now.beginning_of_day + time).strftime("%H:%M")
  end
end
