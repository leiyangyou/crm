class Admin::SchedulesController < Admin::ApplicationController
  before_filter "set_current_tab('admin/schedules')", :only => [ :index, :show ]
  before_filter :load_schedules, :except => [:index]
  skip_before_filter :require_admin_user
  before_filter :require_manager

  def index
    today = Date.today
    redirect_to :action => :show, :year => "%04d" % today.year, :month => "%02d" % today.month, :day => "%02d" % today.day
  end

  def show
    respond_to do |format|
      format.html {
        if request.xhr?
          render :partial => "admin/schedules/show"
        else
          render
        end
      }
    end
  end

  def edit

  end

  def update
    users_to_schedules_map = Hash[@schedules.map {|u, l| [u.id, Hash[l.map {|s| [s.date.to_s("%Y-%m-%d"), s]}]]}]

    @errors = []

    DailySchedule.transaction do
      params[:schedules].each do |u, l|
        l.each do |d, w|
          s = users_to_schedules_map[u.to_i][d]
          s.working_time = DailySchedule::Utils.compact(w)
          @errors << s unless s.save
        end
      end
      if @errors.size > 0
        raise ActiveRecord::Rollback
      end
    end
  end

  private
  def load_schedules
    day = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
    beginning_of_week, end_of_week = day.beginning_of_week(Schedule::FIRST_DAY_OF_WEEK), day.end_of_week(Schedule::FIRST_DAY_OF_WEEK)
    @dates = (beginning_of_week..end_of_week).to_a
    @schedules = current_user.subordinates.map do |subordinate|
      [subordinate,
       subordinate.weekly_schedules(beginning_of_week)]
    end
  end
end
