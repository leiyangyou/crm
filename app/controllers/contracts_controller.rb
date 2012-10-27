class ContractsController < ApplicationController
  before_filter :require_user

  layout false

  load_and_authorize_resource

  # GET /contract_templates/id/contracts/new
  def new
    @callback = params[:callback]
    @template_type = ContractType.find_by_url(params[:contract_type_id])
    if @template_type
      @template = @template_type.contract_templates.master
      if @template
        @contract = Contract.new
        @contract.contract_template = @template
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