class ContractTemplate < ActiveRecord::Base
  belongs_to :contract_type
  has_one :contract_suspension
  has_one :contract_transfer
  attr_accessible :template
  serialize :parameter, Hash

  def template= template
    write_attribute(:template, template)
    parameters = Contract::Parser.instance.parse( template, errors)
    self.parameters = parameters
  end

  def generate_contract parameters

  end
end
