class AppointmentsController < ApplicationController
  before_filter :require_user

  load_and_authorize_resource

  def show
    @appointment = Appointment.new params[:id]
  end

  def cancel
    @appointment = Appointment.find params[:id]
    @appointment.cancel
  end

  def destroy
    @appointment = Appointment.find params[:id]
    @appointment.destroy
  end
end
