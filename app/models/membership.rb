class Membership < ActiveRecord::Base
  belongs_to :account
  belongs_to :consultant, :class_name => 'User'
  belongs_to :contract
  belongs_to :type, :class_name => "MembershipType", :foreign_key => "type_id"
  has_many :membership_suspensions
  has_one :membership_terminations
  has_one :membership_transfers
  attr_accessible :due_date, :duration, :contract_id
  validates_presence_of :membership_type_id

  before_validation do
    contract = Contract.find_by_contract_id(params[:contract_id])
    raise "Cannot find contract for id '#{contract_id}'" unless contract
    self.contract = contract
  end
end
