class SchedulesController < ApplicationController
  before_filter :require_user
  def index
    begin_date, end_date = parse_date_params
    subordinates = current_user.subordinates
    @schedules = {}
    (begin_date)
  end

  def update
    @schedule = current_user.schedules.for_date(params[:date])
    if @schedule.update_attributes(params[:schedule])
    else
    end
  end

  def parse_date_params
    today = Date.today
    begin_date = params[:begin_date] ? Date.parse(params[:begin_date]) : today.beginning_of_week
    end_date = params[:end_date] ? Date.parse(params[:end_date]) : today.end_of_week
    end_date = begin_date.beginning_of_week if end_date < begin_date
    return begin_date, end_date
  end
end
