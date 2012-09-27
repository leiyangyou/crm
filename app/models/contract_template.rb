class ContractTemplate < ActiveRecord::Base
  belongs_to :contract_type
  has_one :contract_suspension
  has_one :contract_transfer
  attr_accessible :template
  serialize :parameter, Hash

  before_validation(:on => :create) do
    parameters = Contract::Parser.instance.parse( self.template, self.errors)
    puts "#{parameters}"
    self.parameters = parameters
  end

  def generate_contract parameters

  end
end
