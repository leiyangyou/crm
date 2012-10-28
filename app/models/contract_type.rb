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
    klass = instance.kind_of?( Class) ? instance : instance.class
    type =
        if klass.respond_to? :contract_type
          klass.contract_type
        else
          klass.name.to_url
        end
    find_by_url type
  end

  def to_param
    url
  end
end
