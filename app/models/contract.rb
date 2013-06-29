class Contract < ActiveRecord::Base
  def self.contracts
    @contracts ||= [Contracts::MembershipContract,
                    Contracts::MembershipTransferContract,
                    Contracts::MembershipSuspendContract,
                    Contracts::LessonContract,
                    Contracts::LockerContract,
                    Contracts::LessonTransferContract]
  end

  belongs_to :account
  attr_protected :account_id, :parameters, :signed_at
  sortable :by => ["signed_at DESC", "started_at DESC", "end_at DESC", "created_at DESC"], :default => "created_at DESC"
  validates_presence_of :finished_on, :started_on
  uses_user_permissions
  has_paper_trail

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

  after_validation :generate_contract_id, :on =>:create
  after_validation :generate_content
  after_validation :generate_abstract

  scope :membership_contracts, lambda {
    where(:type => [
      "Contracts::MembershipContract",
      "Contracts::MembershipTransferContract",
      "Contracts::MembershipSuspendContract",
    ])
  }

  scope :lesson_contracts, lambda {
    where(:type =>["Contracts::LessonContract"])
  }

  scope :lesson_transfer_contracts, lambda {
    where(:type =>["Contracts::LessonTransferContract"])
  }

  scope :locker_contracts, lambda {
    where(:type => "Contracts::LockerContract")
  }

  scope :unsigned, lambda {
    where("contracts.status = ?", 'ready')
  }


  def contract_type
    :membership
  end

  def type_name
    "#{type.underscore.match(/\/(.+)/)[1]}"
  end

  def self.generate_contract_id
    "C#{SecureRandom.hex(6).upcase}"
  end

  def to_param
    contract_id
  end

  protected
  def generate_contract_id
    begin
      contract_id = sprintf("07d", id);
    end while self.class.find_by_contract_id(contract_id)
    self.contract_id = contract_id
  end

  def generate_content
    template = ContractTemplate.find_by_contract_type(self.class.to_s)
    self.content = template ? template.generate_contract(self) : "Connot find template for '#{self.class.to_s}'"
  end

  def generate_abstract
    self.abstract = ""
  end

  def signed
  end
end
