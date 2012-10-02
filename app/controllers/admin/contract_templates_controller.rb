class Admin::ContractTemplatesController < Admin::ApplicationController
  before_filter "set_current_tab('admin/contract_templates')", :only => [ :index, :show ]
  def index
    @contracts_templates = ContractTemplate.all
    @contract_template = ContractTemplate.new
  end
  def new
    @contract_template = ContractTemplate.new
  end

  def create
    @contract_template = ContractTemplate.new(params[:contract_template])
    respond_to do |format|
      if @contract_template.save
        redirect_to @contract_template, notice: 'Contract was successfully created.'
      else
        render action: "new"
      end
    end
  end

  def edit
    @contract_template = ContractTemplate.find(params[:id])
  end

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

  def preview
    @contract_template = ContractTemplate.new(params[:contract_template])
    respond_with(@contract_template) do |format|
      format.html {}
      format.json {render :text => @contract_template.to_printable}
    end
  end
end
