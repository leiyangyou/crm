class Membership < ActiveRecord::Base
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

  scope :transfer_acceptable, where(:status => ['expired', 'transferred'])

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
    event :state_renew do
      transition all => :active
    end
    event :state_expire do
      transition :active => :expired
    end

    after_transition :active => any, :do => :accumulate_membership_duration

  end

  def transfer contract
    target = contract.target
    target_membership = target.membership
    self.state_transfer
    target_membership.accept_transfer(contract)
    self.finished_on = contract.started_on
    self.new_membership_state
  end

  def suspend params
    membership_params = params[:membership] || {}
    self.update_attributes( [:started_on, :finished_on, :contract_id].reduce({}){|r, e| r[e] = membership_params[e]; r})
    self.state_suspend
    suspend_state = self.new_membership_state
    last_active_state = suspend_state.find_last_state MembershipState::TYPES::ACTIVE

    #save the remaining date of last active state to the current suspend state
    remaining_date = 0
    if last_active_state
      remaining_date = (last_active_state.finished_on - last_active_state.started_on) - (Date.today - last_active_state.started_on)
    end
    suspend_state.remaining_date = remaining_date
    suspend_state.save!
  end

  def resume params
    self.state_resume
    last_active_state = current_state.find_last_state MembershipState::TYPES::ACTIVE
    if last_active_state
      self.contract_id = last_active_state.contract_id #use the contract from the last active_state
      suspend_state = self.current_state
      if suspend_state && last_active_state
        remaining_date = suspend_state.remaining_date || 0
        self.started_on = Date.today
        self.finished_on = self.started_on + remaining_date
        self.new_membership_state
      end
      self.save
    end
  end

  def renew contract
    self.started_on = contract.started_on
    membership_type = contract.membership_type
    self.finished_on = self.started_on + membership_type.duration
    self.contract_id = contract.contract_id
    self.type_id = contract.type_id
    self.state_renew
    self.new_membership_state
  end

  def expire params
    self.state_expire
  end

  def self.create_for(account, params)
    if params
      membership = account.membership
      if membership
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
    self.type_id = contract.type_id
    self.state_renew
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
    state.save!
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
