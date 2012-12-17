class Admin::ContractTypesController < Admin::ApplicationController
  before_filter "set_current_tab('admin/contract_types')", :only => [ :index, :show ]
  skip_before_filter :require_admin_user
  before_filter "require_manager(ContractTypes)"

  load_resource
  # GET /contract_types
  # GET /contract_types.json
  def index
    respond_with(@contract_types)
  end

  # GET /contract_types/new
  # GET /contract_types/new.json
  # AJAX
  def new
    respond_with(@contract_type)
  end

  # GET /contract_types/1/edit
  # AJAX
  def edit
    if params[:previous].to_s =~ /(\d)\z/
      @previous = ContractType.find_by_id($1) || $1.to_i
    end
  end

  # POST /contract_types
  # AJAX
  def create
    @contract_type = ContractType.new(params[:contract_type])

    respond_with(@contract_type) do |format|
      @contract_type.save
    end
  end

  # PUT /contract_types/1
  # AJAX
  def update
    @contract_type = ContractType.find(params[:id])

    respond_with(@contract_type) do |format|
      @contract_type.update_attributes(params[:contract_type])
    end
  end

  # DELETE /contract_types/1
  # AJAX
  def destroy
    @contract_type = ContractType.find(params[:id])
    @contract_type.destroy
    respond_with(@contract_type)
  end
end
