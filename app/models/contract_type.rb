class ContractType < ActiveRecord::Base
  attr_accessible :description, :name
  has_many :contract_templates
  has_many :contracts
end
