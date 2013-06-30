class Admin::ContractTemplatesController < Admin::ApplicationController
  before_filter "set_current_tab('admin/contract_templates')", :only => [ :index, :show ]

  load_resource :contract_template
  layout false, :only => [:preview]

  skip_before_filter :require_admin_user
  before_filter "require_manager(ContractTemplate)"

  # GET /contract_types/1/contract_templates
  # AJAX
  def index
    respond_with(@contract_templates)
  end

  # GET /contract_types/1/contract_templates/new
  # AJAX
  def new
    respond_with(@contract_template)
  end

  # POST /contract_types/1/contract_templates
  # AJAX
  def create
    params[:contract_template][:format] = "html"
    @contract_template = ContractTemplate.new(params[:contract_template])
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
      @contract_template.update_attributes(params[:contract_template])
    end
  end

  # DELETE /contract_templates/1
  # AJAX
  def destroy
  end
end
