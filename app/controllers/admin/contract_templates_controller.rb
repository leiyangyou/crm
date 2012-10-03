class Admin::ContractTemplatesController < Admin::ApplicationController
  before_filter "set_current_tab('admin/contract_templates')", :only => [ :index, :show ]

  load_resource :contract_type, :only => [:index, :new, :create]
  load_resource :contract_template, :through => :contract_type, :only => [:index, :new, :create]
  load_resource :contract_template, :only => [:edit, :update, :destroy]
  # GET /contract_types/1/contract_templates
  # AJAX
  def index
    response_with(@contract_templates)
  end

  # GET /contract_types/1/contract_templates/new
  # AJAX
  def new
    respond_with(@contract_template)
  end

  # POST /contract_types/1/contract_templates
  # AJAX
  def create
    @contract_template = ContractTemplate.new(params[:contract_template])
    @contract_template.contract_type = @contract_type
    respond_with(@contract_template) do |format|
      @contract_template.save
    end
  end

  # GET /contract_templates/1/edit
  # AJAX
  def edit
    @contract_template = ContractTemplate.find(params[:id])
  end

  # PUT /contract_templates/1
  # AJAX
  def update
    @contract_template = ContractTemplate.find(params[:id])
    respond_with(@contract_template) do |format|
      if @contract_template.update_attributes(params[:contract_template])
        redirect_to @contract_template
      else
        render action: "update"
      end
    end
  end

  # DELETE /contract_templates/1
  # AJAX
  def destroy
  end

  # POST /contract_templates/preview
  # AJAX
  def preview
    @contract_template = ContractTemplate.new(params[:contract_template])
    respond_with(@contract_template) do |format|
      format.html {}
      format.json {render :text => @contract_template.to_printable}
    end
  end
end
