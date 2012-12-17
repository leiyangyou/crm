class Admin::UserRanksController < Admin::ApplicationController
  before_filter "set_current_tab('admin/user_ranks')", :only => [ :index ]
  skip_before_filter :require_admin_user
  before_filter "require_manager(UserRank)"
  load_and_authorize_resource

  def index
    @trainer_ranks = @user_ranks.where(:type => "trainer").order("rank_override")
    @consultant_ranks = @user_ranks.where(:type => "consultant").order("rank_override")
  end

  def sort
    role = params[:type]
    params[:"#{role}_ranks"].each_with_index do |id, index|
      UserRank.update_all(['rank_override=?', index], ['id=?', id])
    end
    instance_variable_set("@#{role}_ranks", @user_ranks.where(:type => role).order("rank_override"))
  end
end
