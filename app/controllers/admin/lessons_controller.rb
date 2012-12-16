class Admin::LessonsController < Admin::ApplicationController
  before_filter "set_current_tab('admin/lessons')", :only => [ :index, :show ]
  skip_before_filter :require_admin_user
  before_filter "require_manager(Lesson)"

  load_resource

  def create
    @lesson = Lesson.new(params[:lesson])

    respond_with(@lesson) do |format|
      @lesson.save
    end
  end

  def update
    @lesson = Lesson.find(params[:id])
    respond_with(@lesson) do |format|
      @lesson.update_attributes(params[:lesson])
    end
  end

  def destroy
    @lesson = Lesson.find(params[:id])
    @lesson.destroy
    respond_with(@lesson)
  end
end
