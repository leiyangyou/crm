HomeController.class_eval do
  def get_activities(options = {})
    options[:asset]    ||= activity_asset
    options[:event]    ||= activity_event
    options[:user]     ||= activity_user
    options[:duration] ||= activity_duration
    options[:users] ||= activity_users

    Version.latest(options).visible_to(@current_user)
  end

  def options
    unless params[:cancel].true?
      @asset = @current_user.pref[:activity_asset] || "all"
      @action = @current_user.pref[:activity_event] || "all_events"
      @user = @current_user.pref[:activity_user] || "all_users"
      @duration = @current_user.pref[:activity_duration] || "two_days"
      @all_users = User.manageable_by(@current_user).order("first_name, last_name")
    end
  end

  private
  def activity_users
    User.manageable_by(@current_user).select(:id).map(&:id).map(&:to_s)
  end
end