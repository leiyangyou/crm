class ContractType < ActiveRecord::Base
  attr_accessible :description, :name
  has_many :contract_templates, :dependent => :delete_all
  has_many :contracts
end
