class ContractTemplate < ActiveRecord::Base
  belongs_to :contract_type

  attr_accessible :template
  serialize :parameter, Hash

  before_validation(:on => :create) do
    self.parse_and_refresh_parameters
  end

  before_validation(:on => :update) do
    if self.template_chnaged?
      self.parse_and_refresh_parameters
    end
  end

  def to_printable
  end

  def generate_contract params
    contract = Contract.new params
    contract.template = self
    contract
  end

  protected

  def parse_and_refresh_parameters
    parameters = Contract::Parser.instance.parse_parameters( self.template, self.errors)
    self.parameters = parameters
  end
end
