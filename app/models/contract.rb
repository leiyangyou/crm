module ContractDecorator
end
class Contract < ActiveRecord::Base
  def self.contracts
    @contracts ||= [Contracts::MembershipTransferContract, Contracts::MembershipTransferContract, Contracts::MembershipSuspendContract, Contracts::LessonContract, Contracts::LockerContract]
  end

  include ContractDecorator::ContractFields
  belongs_to :account
  attr_accessible :content, :contract_id, :finished_on, :parameters, :signed_at, :started_on, :status, :parameters_attributes, :type
  sortable :by => ["signed_at DESC", "started_at DESC", "end_at DESC", "created_at DESC"], :default => "created_at DESC"
  validates_presence_of :contract_id, :finished_on, :parameters, :started_on
  uses_user_permissions
  has_paper_trail
  module FieldTypes
    DATE = "date"
    STRING = "string"
    NUMBER = "number"
    TEXT = "text"
  end

  serialize :parameters, Hash
  attr_accessor :parameters_attributes

  state_machine :status, :initial => :ready do
    event :sign do
      transition :ready => :signed
    end

    event :terminate do
      transition :signed => :terminated
    end

    before_transition :to => :signed do |contract|
      contract.signed_at = Time.now
      contract.signed
    end
  end

  before_validation :generate_contract_id, :on =>:create
  after_validation :generate_content
  after_validation :generate_abstract

  def self.generate_contract_id
    "C#{SecureRandom.hex(6).upcase}"
  end


  def parameters_attributes= attributes
    assign_fields attributes
  end

  def to_param
    contract_id
  end

  protected
  def generate_contract_id
    begin
      contract_id = Contract.generate_contract_id
    end while Contract.find_by_contract_id(contract_id)
    self.contract_id = contract_id
  end

  def generate_content
    template = ContractTemplate.find_by_contract_type(self.class.to_s)
    self.content = template ? template.generate_contract(self) : "Connot find template for '#{self.class.to_s}'"
  end

  def parameters
    parameters = read_attribute(:parameters)
    return parameters if parameters
    parameters = {}
    write_attribute(:parameters, paramters)
    parameters
  end

  def generate_abstract
    self.abstract = ""
  end

  def signed
  end
end
require File.join(File.dirname(__FILE__), "contracts/lesson_contract")
require File.join(File.dirname(__FILE__), "contracts/locker_contract")
require File.join(File.dirname(__FILE__), "contracts/membership_contract")
require File.join(File.dirname(__FILE__), "contracts/membership_suspend_contract")
require File.join(File.dirname(__FILE__), "contracts/membership_transfer_contract")

