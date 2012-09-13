Admin::UsersController.class_eval do
  skip_before_filter :require_admin_user
  before_filter :require_manager

  def create
    roles = params[:user].delete(:roles)
    params[:user][:password_confirmation] = nil if params[:user][:password_confirmation].blank?

    @user = User.new(params[:user])
    @user.roles = roles
    @user.admin = @user.is?(:admin)
    @user.admin = (params[:user][:admin] == "1")
    @user.save_without_session_maintenance
    @users = get_users

    respond_with(@user)
  end

  def update
    roles = params[:user].delete(:roles)

    params[:user][:password_confirmation] = nil if params[:user][:password_confirmation].blank?

    @user = User.find(params[:id])
    @user.roles = roles
    @user.admin = @user.is?(:admin)
    @user.update_attributes(params[:user])

    respond_with(@user)
  end

  protected
  def require_manager
    require_user
    if @current_user &&
        !@current_user.admin? &&
        (Set.new(@current_user.roles) &
         Set.new([:operator_manager, :trainer_manager, :consultant_manager, :general_manager, :admin])).size == 0
      flash[:notice] = t(:msg_require_admin)
      redirect_to root_path
    end
  end
end
