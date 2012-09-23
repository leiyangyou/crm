class Admin::SchedulesController < Admin::ApplicationController
  before_filter "set_current_tab('admin/schedules')", :only => [ :index, :show ]
  before_filter :require_manager

  def index
    beginning_of_week, end_of_week = parse_date_params
    subordinates = current_user.subordinates
    @schedules = {}
    @dates = (beginning_of_week..end_of_week).to_a
    out_of_date = Date.today.end_of_week < begin_date
    subordinates.each do |subordinate|
      unless out_of_date
        @dates.reduce([]) do |result, date|
          subordinate.schedule.for_date(date)
        end
      end
    end
  end

  def show
    @schedule = Schedule.find(params[:id])
  end

  def new
    @schedule = Schedule.new
  end

  def create
    @schedule = Schedule.new(params[:schedule])
    if @schedule.save
    else
    end
  end

  def update
    @schedule = current_user.schedules.for_date(params[:date])
    if @schedule.update_attributes(params[:schedule])
      #TODO
    else
      #TODO
    end
  end

  private
  def parse_date_params
    today = Date.today
    date = params[:date] ? Date.parse(params[:date]) : today.beginning_of_week
    return date.beginning_of_week, date.end_of_week
  end
end
