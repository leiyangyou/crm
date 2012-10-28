class Admin::LockersController < Admin::ApplicationController
  before_filter "set_current_tab('admin/lockers')", :only => [ :index, :show ]

  load_resource

  def index
    respond_with(@lockers)
  end

  def new
    respond_with(@locker)
  end

  def create
    @locker = Locker.new(params[:locker])
    respond_with(@locker) do |format|
      @locker.save
    end
  end

  def destroy
    @locker = Locker.find(params[:id])
    @locker.destroy
    respond_with(@locker)
  end
end