class ContractTemplate < ActiveRecord::Base
  belongs_to :contract_type
  attr_accessible :parameters, :template
end
