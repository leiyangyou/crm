class ContractsController < ApplicationController
  before_filter :require_user

  load_resource :account, :only => [:new, :create]

  layout false, :only => [:preview]

  # GET /accounts/:account_id/contracts/new?type=:contract_type
  def new
    @account = Account.find(params[:account_id])
    unless params[:contract_type]
      render :text => "contract_type is required"
    end
    contract_class = params[:contract_type].constantize
    @contract = contract_class.new
    @contract.account = @account
  end

  # GET /contracts
  def index
    @contracts = Contract.paginate(:page => params[:page])
  end

  # GET /contracts/:contract_id
  def show
    @contract = Contract.find_by_contract_id params[:id]
  end

  # POST /contracts/preview
  def preview
    @contract = Contract.new(params[:contract])
  end

  #POST /contracts/:id/sign
  def sign
    @contract = Contract.find_by_contract_id(params[:id])
    @contract.sign if @contract
  end

  # POST /contracts
  def create
    contract_type = params[:contract].delete(:type)
    contract_class = contract_type.constantize
    @contract = contract_class.new params[:contract]
    @contract.account = @account
    if @contract.save
      redirect_to contracts_path
    else
      render :new
    end
  end

end