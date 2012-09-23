class Admin::SchedulesController < Admin::ApplicationController
  before_filter "set_current_tab('admin/schedules')", :only => [ :index, :weekly, :show ]
  before_filter :require_manager

  def index
    today = Date.today
    redirect_to :action => :weekly, :year => "%04d" % today.year, :month => "%02d" % today.month, :day => "%02d" % today.day
  end

  def weekly
    day = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
    beginning_of_week, end_of_week = day.beginning_of_week(Schedule::FIRST_DAY_OF_WEEK), day.end_of_week(Schedule::FIRST_DAY_OF_WEEK)
    @dates = (beginning_of_week..end_of_week).to_a
    @schedules = current_user.subordinates.map do |subordinate|
      [subordinate,
       subordinate.find_or_create_schedule_by_week(beginning_of_week)]
    end
    respond_to do |format|
      format.html {
        if request.xhr?
          render :partial => "admin/schedules/schedules"
        else
          render
        end
      }
    end
  end
end
