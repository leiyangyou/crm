UsersController.class_eval do

  def new_appointment
    @user = User.find(params[:id])
    @appointment = Appointment.new
    @appointment.date = Date.today unless @appointment.date
  end

  def add_appointment
    @user = User.find(params[:id])
    @appointment = Appointment.new params[:appointment]
    @appointment.date = Date.today unless @appointment.date
    @user.add_appointment @appointment
  end

  def appointments
    @date = extract_date_from_params(params)
    @user = User.find(params[:id])
  end

  private

  def extract_date_from_params params
    if params[:date]
      begin
        return Date.parse(params[:date])
      rescue Exception => e
      end
    elsif [:year, :month, :day].all?{|section| params.include?(section)}
      return Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
    end
    Date.today
  end
end