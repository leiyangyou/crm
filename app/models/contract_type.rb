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
    return instance.underscore.to_url.squish if instance.kind_of?(String)
    klass = instance.kind_of?( Class) ? instance : instance.class
    if klass.respond_to? :contract_type
      klass.contract_type
    else
      klass.name.underscore.to_url.squish
    end
  end

  def to_param
    url
  end
end
