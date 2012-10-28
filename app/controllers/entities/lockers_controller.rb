class LockersController < EntitiesController

  alias :get_lockers :get_list_of_records
  def index
    @lockers = get_lockers(:page => params[:page])
    respond_with(@lockers)
  end

  def new_rent
    @locker = Locker.find(params[:id])
    @locker_rent = LockerRent.new
    @locker_rent.locker = @locker
  end

  def create_rent
    @locker = Locker.find(params[:id])
    @locker_rent = LockerRent.new(params[:locker_rent])
    @locker.locker_rent = @locker_rent
    respond_with(@locker_rent) do |format|
      if @locker_rent.save
        @locker.rent
      end
    end
  end

  def restore
    @locker = Locker.find(params[:id])
    @locker.restore
  end
end