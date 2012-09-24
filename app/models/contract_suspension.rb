class ContractSuspension < ActiveRecord::Base
  belongs_to :contract
  belongs_to :new_contract
  attr_accessible :reason
end
