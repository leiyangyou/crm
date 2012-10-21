class LockersController < ApplicationController
  # GET /lockers
  # GET /lockers.json
  def index
    @lockers = Locker.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lockers }
    end
  end

  # GET /lockers/1
  # GET /lockers/1.json
  def show
    @locker = Locker.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @locker }
    end
  end

  # GET /lockers/new
  # GET /lockers/new.json
  def new
    @locker = Locker.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @locker }
    end
  end

  # GET /lockers/1/edit
  def edit
    @locker = Locker.find(params[:id])
  end

  # POST /lockers
  # POST /lockers.json
  def create
    @locker = Locker.new(params[:locker])

    respond_to do |format|
      if @locker.save
        format.html { redirect_to @locker, notice: 'Locker was successfully created.' }
        format.json { render json: @locker, status: :created, location: @locker }
      else
        format.html { render action: "new" }
        format.json { render json: @locker.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lockers/1
  # PUT /lockers/1.json
  def update
    @locker = Locker.find(params[:id])

    respond_to do |format|
      if @locker.update_attributes(params[:locker])
        format.html { redirect_to @locker, notice: 'Locker was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @locker.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lockers/1
  # DELETE /lockers/1.json
  def destroy
    @locker = Locker.find(params[:id])
    @locker.destroy

    respond_to do |format|
      format.html { redirect_to lockers_url }
      format.json { head :no_content }
    end
  end
end
