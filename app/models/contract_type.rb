class ContractType < ActiveRecord::Base
  attr_accessible :description, :name
  has_many :contract_templates, :dependent => :delete_all do
    def master
      order_by("created_at DESC").first
    end
  end
  has_many :contracts
end
