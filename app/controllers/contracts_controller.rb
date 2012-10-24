class ContractsController < ApplicationController
  before_filter :require_user

  layout false

  load_and_authorize_resource

  # GET /contract_templates/id/contracts/new
  def new
    @callback = params[:callback]
    @template = ContractTemplate.find(params[:contract_template_id])
    if @template
      @contract = Contract.new
      @contract.contract_template = @template
    end
  end

  # POST /contracts/preview
  def preview
    @contract = Contract.new(params[:contract])
  end

  # POST /contracts
  def create
    @contract = Contract.new(params[:contract])
    respond_with(@contract) do
      @contract.save
    end
  end

end