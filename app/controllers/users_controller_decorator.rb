UsersController.class_eval do

  def add_appointment
    @user = User.find(params[:id])
    @appointment = Appointment.new params[:appointment]
    @appointment.date = Date.today unless @appointment.date
    @user.add_appointment @appointment
  end
end