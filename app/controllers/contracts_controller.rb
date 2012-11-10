class ContractsController < ApplicationController
  before_filter :require_user

  layout false

  load_and_authorize_resource :find_by => :contract_id

  # GET /contract_templates/id/contracts/new
  def new
    @callback = params[:callback]
    @contract_type = ContractType.find_by_url(params[:contract_type_id])
    if @contract_type
      @template = @contract_type.contract_templates.master
      if @template
        @contract = Contract.new
        @contract.contract_template = @template
        @contract.parameters_attributes = params
      end
    end
  end

  # POST /contracts/preview
  def preview
    @contract = Contract.new(params[:contract])
  end

  # POST /contracts
  def create
    @contract = Contract.new(params[:contract])
    @callback = params[:callback]
    respond_with(@contract) do
      @contract.save
    end
  end

end