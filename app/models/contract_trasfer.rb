class ContractTrasfer < ActiveRecord::Base
  belongs_to :contract
  belongs_to :new_contract
  # attr_accessible :title, :body
end
