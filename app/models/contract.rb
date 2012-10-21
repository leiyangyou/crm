require File.join(File.dirname(__FILE__), "/contract/parameters_assignment")
require File.join(File.dirname(__FILE__), "/contract/contract_parameter")
class Contract < ActiveRecord::Base
  has_one :contract_suspension
  belongs_to :contract_template
  belongs_to :contract_type
  #belongs_to :offeree, :polymorphic => true
  #belongs_to :created_by,
  attr_accessible :content, :contract_id, :end_at, :parameters, :signed_at, :started_at, :status, :parameters_attributes, :contract_template_id
  sortable :by => ["signed_at DESC", "started_at DESC", "end_at DESC", "created_at DESC"], :default => "created_at DESC"
  validates_presence_of :content, :contract_id, :end_at, :parameters, :signed_at, :started_at
  validates_presence_of :contract_template_id
  include ParametersAssignment
  uses_user_permissions
  has_paper_trail
  include ContractParameter
  contract_parameter :started_at, :end_at

  serialize :parameters, Contract::Params
  attr_accessor :parameters_attributes

  before_validation :attribute_signed_at, :on => :create
  before_validation :generate_contract_id, :on =>:create
  before_validation :generate_content


  def self.generate_contract_id
    "C#{SecureRandom.hex(6).upcase}"
  end


  def parameters_attributes= attributes
    self.parameters = Contract::Params.new
    assign_parameters( attributes)
  end

  protected
  def generate_contract_id
    begin
      contract_id = Contract.generate_contract_id
    end while Contract.find_by_contract_id(contract_id)
    self.contract_id = contract_id
  end

  def parameters
    parameters = read_attribute(:parameters)
    return parameters if parameters
    parameters = Contract::Param.new
    write_attribute(:parameters, paramters)
    parameters
  end

  def generate_content
    parameters = self.parameters.merge(self.contract_parameters)
    self.content = self.contract_template.generate_contract parameters
  end

  def attribute_signed_at
    self.signed_at = Time.now
  end
end
