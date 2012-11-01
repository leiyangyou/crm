class Membership < ActiveRecord::Base
  belongs_to :account
  belongs_to :consultant, :class_name => 'User'
  belongs_to :contract
  belongs_to :type, :class_name => "MembershipType", :foreign_key => "type_id"
  has_many :membership_suspensions
  has_one :membership_terminations
  has_one :membership_transfers
  attr_accessible :start_date, :contract_id, :type_id, :consultant_id
  validates_presence_of :type_id

  after_find :check_expiration

  state_machine :status, :initial => :expired do
    event :transfer do
      transition :normal => :transferred
    end
    event :suspend do
      transition :normal => :suspended
    end
    event :continue do
      transition :suspended => :normal
    end
    event :renewal do
      transition :expired => :normal
    end
    event :expire do
      transition :normal => :expired
    end
  end

  def self.create_or_select_for(account, params)
    if params && !params.empty?
      membership = account.membership
      if membership
        membership.update_attributes(params)
      else
        membership = Membership.new(params)
      end
      membership.save
    end
  end

  def create_suspension( params)
    suspension = MembershipSuspension.new(params)
    suspension.membership = self
    if suspension.save
      self.suspend
    end
    suspension
  end

  def total_duration
    self.duration + Date.today - start_date
  end

  def should_accumulate_membership_duration?
    ! self.transferred?
  end

  def check_expiration
    if self.normal? && self.due_date < Date.today
      self.expire
    end
  end
end
