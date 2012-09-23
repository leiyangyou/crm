class Admin::SchedulesController < Admin::ApplicationController
  before_filter "set_current_tab('admin/schedules')", :only => [ :index, :show ]
  before_filter :require_manager

  def index
    begin_date, end_date = parse_date_params
    subordinates = current_user.subordinates
    @schedules = {}
    (begin_date)
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

  def edit
    @schedule = Schedule.find(params[:id])
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
    begin_date = params[:begin_date] ? Date.parse(params[:begin_date]) : today.beginning_of_week
    end_date = params[:end_date] ? Date.parse(params[:end_date]) : today.end_of_week
    end_date = begin_date.beginning_of_week if end_date < begin_date
    return begin_date, end_date
  end
end
