class Membership < ActiveRecord::Base
  belongs_to :account
  belongs_to :consultant, :class_name => 'User'
  belongs_to :contract
  belongs_to :type, :class_name => "MembershipType", :foreign_key => "type_id"
  has_many :membership_suspensions do
    def latest
      order('created_at DESC').first
    end
  end
  has_one :membership_termination
  has_one :membership_transfer, :foreign_key =>  :from_membership_id
  attr_accessible :start_date, :contract_id, :type_id, :consultant_id

  delegate :name, :to => :account

  after_find :check_expiration

  scope :transfer_acceptable, where(:status => ['expired', 'transferred', 'expired'])

  state_machine :status, :initial => :expired do
    event :transfer do
      transition :normal => :transferred
    end
    event :activate do
      transition :inactive => :active
    end
    event :suspend do
      transition :normal => :suspended
    end
    event :continue do
      transition :suspended => :normal
    end
    event :renewal do
      transition all => :inactive
    end
    event :expire do
      transition :normal => :expired
    end
  end

  def self.create_or_select_for(account, params)
    if params
      membership = account.membership
      if membership
        if membership.should_accumulate_membership_duration?
          membership.duration += membership.type.duration if membership.type #accumulate the previous membership
        end
        membership.update_attributes(params)
      else
        membership = Membership.new(params)
      end
      if membership.type
        membership.start_date = Date.today unless membership.start_date
        membership.due_date = membership.start_date + membership.type.duration
        membership.renewal
      end
      account.membership = membership
      membership.save
      membership
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

  def create_transfer(params)
    transfer = MembershipTransfer.new(params)
    transfer.from_membership = self
    target_membership = transfer.to_membership
    target_membership.accept_transfer(self)
    self.due_date = Date.today
    if transfer.save
      self.transfer
    end
    transfer
  end

  def accept_transfer(membership)
    remain = membership.due_date - Date.today
    self.type = membership.type
    self.start_date = Date.today
    self.due_date = Date.today + remain
    self.renewal
    self.save
  end

  def continue_membership
    suspension = membership_suspensions.latest
    if suspension
      remain = self.type.duration - ( suspension.start_date - self.start_date)
      self.start_date = Date.today
      self.due_date = self.start_date + remain
    end
    self.continue
    self.save
    self
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
