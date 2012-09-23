Admin::UsersController.class_eval do
  skip_before_filter :require_admin_user
  before_filter :require_manager
  authorize_resource

  def create
    roles = params[:user_roles] || []
    params[:user][:password_confirmation] = nil if params[:user][:password_confirmation].blank?

    @user = User.new(params[:user])

    User.valid_roles.each do |role|
      if can? :manage, role
        if roles.include? role
          @user.roles << role
        else
          @user.roles.delete role
        end
      end
    end

    @user.roles = roles
    @user.admin = @user.is?(:admin)
    @user.save_without_session_maintenance
    @users = get_users

    respond_with(@user)
  end

  def update
    roles = params[:user_roles] || []

    params[:user][:password_confirmation] = nil if params[:user][:password_confirmation].blank?

    @user = User.find(params[:id])

    User.valid_roles.each do |role|
      if can?(:manage, role) && (!@user == @current_user || can?(:self_assign, role))
        if roles.include? role
          @user.roles << role
        else
          @user.roles.delete role
        end
      end
    end

    @user.admin = @user.is?(:admin)
    @user.update_attributes(params[:user])

    respond_with(@user)
  end

  protected
  def require_manager
    require_user
    if @current_user && cannot?(params[:action].to_sym, User)
      flash[:notice] = t(:msg_require_manager)
      redirect_to root_path
    end
  end

  private
  def get_users(options = {})
    self.current_page  = options[:page] if options[:page]
    self.current_query = params[:query] if params[:query]

    @search = klass.search(params[:q])
    @search.build_grouping unless @search.groupings.any?

    wants = request.format
    scope = User.by_id
    scope = scope.merge(@search.result)
    scope = scope.text_search(current_query)      if current_query.present?
    scope = scope.manageable_by(@current_user) if @current_user
    scope = scope.paginate(:page => current_page) if wants.html? || wants.js? || wants.xml?
    scope
  end
end

