class ContractType < ActiveRecord::Base
  attr_accessible :description, :name
  acts_as_url :name
  has_many :contract_templates, :dependent => :delete_all do
    def master
      order("created_at DESC").first
    end
  end
  has_many :contracts

  def self.type_for instance
    if instance.class.respond_to? :contract_type
      instance.class.contract_type
    else
      instance.class.name.to_url
    end
  end

  def to_param
    url
  end
end
