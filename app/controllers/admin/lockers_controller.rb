class Admin::LockersController < Admin::ApplicationController

  load_resource
  # GET /lockers
  # GET /lockers.json
  def index
  end

  # GET /lockers/1
  # GET /lockers/1.json
  def show
  end

  # GET /lockers/new
  # GET /lockers/new.json
  def new
  end

  # GET /lockers/1/edit
  def edit
  end

  # POST /lockers
  # POST /lockers.json
  def create
    @locker = Locker.new(params[:locker])

    respond_to do |format|
      @locker.save
    end
  end

  # PUT /lockers/1
  # PUT /lockers/1.json
  def update
    @locker = Locker.find(params[:id])
    respond_with(@locker) do |format|
      @locker.update_attributes(params[:locker])
    end
  end

  # DELETE /lockers/1
  # DELETE /lockers/1.json
  def destroy
    @locker = Locker.find(params[:id])
    @locker.destroy
  end
end
