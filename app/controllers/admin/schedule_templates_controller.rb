class ScheduleTemplatesController < Admin::ApplicationController
  # GET /schedule_templates
  # GET /schedule_templates.json
  def index
    @schedule_templates = ScheduleTemplate.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @schedule_templates }
    end
  end

  # GET /schedule_templates/1
  # GET /schedule_templates/1.json
  def show
    @schedule_template = ScheduleTemplate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @schedule_template }
    end
  end

  # GET /schedule_templates/new
  # GET /schedule_templates/new.json
  def new
    @schedule_template = ScheduleTemplate.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @schedule_template }
    end
  end

  # GET /schedule_templates/1/edit
  def edit
    @schedule_template = ScheduleTemplate.find(params[:id])
  end

  # POST /schedule_templates
  # POST /schedule_templates.json
  def create
    @schedule_template = ScheduleTemplate.new(params[:schedule_template])

    respond_to do |format|
      if @schedule_template.save
        format.html { redirect_to @schedule_template, notice: 'Schedule template was successfully created.' }
        format.json { render json: @schedule_template, status: :created, location: @schedule_template }
      else
        format.html { render action: "new" }
        format.json { render json: @schedule_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /schedule_templates/1
  # PUT /schedule_templates/1.json
  def update
    @schedule_template = ScheduleTemplate.find(params[:id])

    respond_to do |format|
      if @schedule_template.update_attributes(params[:schedule_template])
        format.html { redirect_to @schedule_template, notice: 'Schedule template was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @schedule_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /schedule_templates/1
  # DELETE /schedule_templates/1.json
  def destroy
    @schedule_template = ScheduleTemplate.find(params[:id])
    @schedule_template.destroy

    respond_to do |format|
      format.html { redirect_to schedule_templates_url }
      format.json { head :no_content }
    end
  end
end
