class Membership < ActiveRecord::Base
  include Assignable
  belongs_to :account
  belongs_to :consultant, :class_name => 'User'
  belongs_to :type, :class_name => "MembershipType", :foreign_key => "type_id"
  has_many :membership_states do
    def current
      order('created_at DESC').first
    end
  end
  has_one :current_state, :class_name => 'MembershipState', :order => 'created_at DESC'
  attr_accessible :started_on, :finished_on, :type_id, :consultant_id, :contract_id

  delegate :name, :to => :account

  after_find :check_expiration

  scope :transfer_acceptable, where(:status => ['expired', 'transferred', 'expired'])

  state_machine :status, :initial => :expired do
    event :state_transfer do
      transition :active => :transferred
    end
    event :state_suspend do
      transition :active => :suspended
    end
    event :state_resume do
      transition :suspended => :active
    end
    event :state_renewal do
      transition all => :active
    end
    event :state_expire do
      transition :active => :expired
    end

    after_transition :active => any, :do => :accumulate_membership_duration
  end

  def _transfer params
    target_membership = Membership.find(params[:membership_state][:parameters_attributes][:target_id])
    self.update_attributes(params[:membership])
    self.state_transfer
    target_membership.accept_transfer(self)
    self.finished_on = Date.today
    self.new_membership_state(params[:membership_state])
  end

  def transfer contract
    target = contract.target
    target_membership = target.membership
    self.state_transfer
    target_membership.accept_transfer(contract)
    self.finished_on = contract.started_on
    self.new_membership_state
  end

  def suspend contract
    self.started_on = contract.started_on
    self.finished_on = contract.finished_on
    self.contract_id = contract.contract_id
    self.state_suspend
    self.new_membership_state
  end

  def resume params
    self.state_resume
    current_state = self.current_state
    last_suspend_state = current_state.find_last_state MembershipState::TYPES::SUSPENDED
    last_active_state = current_state.find_last_state MembershipState::TYPES::ACTIVE
    if last_suspend_state && last_active_state
      duration = last_active_state.started_on - last_suspend_state.started_on
      remain = self.type.duration - duration
      self.started_on = Date.today
      self.finished_on = self.started_on + remain
    end
  end

  def renewal contract
    self.started_on = contract.started_on
    membership_type = contract.membership_type
    self.finished_on = self.started_on + membership_type.duration
    self.contract_id = contract.contract_id
    self.state_renewal
    self.new_membership_state
  end

  def expire params
    self.state_expire
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
      account.membership = membership
      membership.save
      membership
    end
  end

  def accept_transfer(contract)
    source_account = contract.account
    membership = source_account.membership
    remain = membership.finished_on - Date.today
    self.type = membership.type
    self.started_on = Date.today
    self.finished_on = Date.today + remain
    self.contract_id = contract_id
    self.state_renewal
    self.new_membership_state
    self.save
  end

  def total_duration
    duration = self.duration
    if self.active?
      duration += (Date.today - self.started_on)
    end
    duration
  end

  def check_expiration
    if self.active? && self.finished_on < Date.today
      self.state_expire
    end
  end

  def contract_required?
    %w{active suspended transferred}.include?(self.status)
  end

  def assignable_value
    self.type.try(:price){0}
  end

  protected
  def new_membership_state params = {}
    params = params || {}
    params = params.merge(
        :state_type => self.status
    )
    state = MembershipState.new params
    state.last_state =  self.current_state
    state.state_type = self.status
    state.contract_id = self.contract_id
    state.membership = self
    [:started_on, :finished_on].each do |method|
      if state.respond_to? method
        state.send(:"#{method}=", self.send(:"#{method}"))
      end
    end
    if state.respond_to? :type_id
      state.type_id = self.type_id
    end
    state.save
    state
  end

  def accumulate_membership_duration
    duration = 0
    if current_state
      if status == "transferred"
        transferred_state = self.current_state
        active_state = transferred_state.find_last_state MembershipState::TYPES::ACTIVE
        duration = transferred_state.started_on - active_state.started_on if active_state
      else
        active_state = self.current_state.find_last_state MembershipState::TYPES::ACTIVE
        duration = active_state.finished_on - active_state.started_on if active_state
      end
    end
    self.duration += duration
  end
end
