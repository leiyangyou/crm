
class ContractsController < EntitiesController

  def index
    @contracts = get_list_of_records(:page => params[:page])
    respond_with(@contracts)
  end

  def show
  end

  # GET /contracts/new
  def new
    @contract_templates = ContractTemplate.all
    @contract.contract_template = @contract_templates.first
  end

  # GET /contracts/1/edit
  def edit
  end

  # POST /contracts
  # POST /contracts.json
  def create
    puts @contract.inspect
    respond_with(@contract) do |format|
      @contract.save(params[:contract])
    end
  end

  # PUT /contracts/1
  # PUT /contracts/1.json
  def update
  end

  # DELETE /contracts/1
  # DELETE /contracts/1.json
  def destroy
  end
end
