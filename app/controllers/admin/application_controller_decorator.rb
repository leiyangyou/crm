Admin::ApplicationController.class_eval do
  private
  def require_manager
    require_user
    if @current_user && cannot?(params[:action].to_sym, User)
      flash[:notice] = t(:msg_require_manager)
      redirect_to root_path
    end
  end
end