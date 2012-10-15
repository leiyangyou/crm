class Contract < ActiveRecord::Base
  has_one :contract_suspension
  has_one :contract_transfer
  belongs_to :contract_template
  belongs_to :contract_type
  #belongs_to :offeree, :polymorphic => true
  #belongs_to :created_by,
  attr_accessible :content, :contract_id, :end_at, :parameters, :signed_at, :started_at, :state
  sortable :by => ["signed_at DESC", "started_at DESC", "end_at DESC", "created_at DESC"], :default => "created_at DESC"
  validates_presence_of :content, :contract_id, :end_at, :parameters, :signed_at, :started_at, :created_by
  validates_presence_of :contract_template_id
  validates_presence_of :contract_type_id
  validates_with Contract::Validators::ContractParametersValidator


  serialize :parameters, Contract::Params
  attr_accessor :parameters_attributes

  before_validation :on => :create do
    self.signed_at = Time.now
  end

  def parameters_attributes= attributes
    template = self.contract_template
    parameters = self.contract_template.parameters
    attributes.stringify_keys!
    params = self.parameters || Contract::Params.new
    attributes.each do |key, value|
      param = parameters[key]
      raise ArgumentError "cannot find parameter named '#{key}' in template '#{template.name}'" unless param
      type = Contracttemplate::ParamType.get_type_by_name param.type
      raise ArgumentError "unrecognized type '#{param.type}' for param '#{key}'" unless type
      param_value = Contract::ParamValue.new(type.name, value)
      params[key] = param_value
    end
    @parameters = params
  end
end
