UsersController.class_eval do

  def add_appointment
    @user = User.find(params[:id])
    @appointment = Appointment.new params[:appointment]
    @user.add_appointment @appointment
  end
end