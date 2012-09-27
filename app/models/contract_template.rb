class ContractTemplate < ActiveRecord::Base
  belongs_to :contract_type

  attr_accessible :template
  serialize :parameter, Hash

  before_validation(:on => :create) do
    parameters = Contract::Parser.instance.parse( self.template, self.errors)
    puts "#{parameters}"
    self.parameters = parameters
  end

  def to_printable

  end

  def generate_contract params
    contract = Contract.new params
    contract.template = self
    contract
  end
end
