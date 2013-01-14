class Membership < ActiveRecord::Base
  belongs_to :account
  belongs_to :consultant, :class_name => 'User'
  belongs_to :type, :class_name => "MembershipType", :foreign_key => "type_id"
  has_many :membership_states do
    def current
      order('created_at DESC').first
    end
  end
  belongs_to :current_state, :class_name => 'MembershipState', :foreign_key => 'current_state_id'
  attr_accessible :started_on, :finished_on, :type_id, :consultant_id, :contract_id

  delegate :name, :to => :account

  after_find :check_expiration

  after_create :create_initialize_state

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

  def can_renew?
    (self.active? || self.expired?) && !self.current_state.future_state
  end

  def transfer contract
    target = contract.target
    if target
      target_membership = target.membership
      self.started_on = contract.source_contract_finished_on
      self.state_transfer
      new_state = self.to_state
      new_state.target_id = contract.target_id
      target_membership.accept_transfer(contract)
      self.new_state new_state
    else
      logger.error("Cannot find account for target_id: '#{contract.target_id}'")
    end
    self.save
  end

  def suspend params
    membership_params = params[:membership] || {}

    self.update_attributes( [:started_on, :finished_on, :contract_id].reduce({}){|r, e| r[e] = membership_params[e]; r})
    self.state_suspend
    suspend_state = self.to_state
    last_active_state = current_state

    #save the remaining date of last active state to the current suspend state
    remaining_days = 0
    if last_active_state
      remaining_days = (last_active_state.finished_on - last_active_state.started_on) - (Date.today - last_active_state.started_on)
    end
    suspend_state.remaining_days = remaining_days
    self.new_state suspend_state
    self.save
  end

  def resume
    self.state_resume
    last_active_state = current_state.find_last_state MembershipState::TYPES::ACTIVE
    if last_active_state
      self.contract_id = last_active_state.contract_id #use the contract from the last active_state
      suspend_state = self.current_state
      if suspend_state && last_active_state
        remaining_days = suspend_state.remaining_days || 0
        self.started_on = Date.today
        self.finished_on = self.started_on + remaining_days
        self.state_resume
        new_state = self.to_state
        self.new_state new_state
      end
      self.save
    end
  end

  def renew contract
    if self.active?
      state = self.extract_state_from_renew_contract(contract)
      self.add_future_state(state)
    else
      state = self.extract_state_from_renew_contract(contract)
      if contract.started_on > Date.today
        self.finished_on = contract.started_on
        self.add_future_state(state)
      else
        self.state_renew
        self.new_state(state)
      end
    end
    self.save
  end

  def expire
    self.state_expire
    self.started_on = Date.today
    self.finished_on = nil
    new_state = self.to_state
    self.new_state( new_state)
    self.save
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
    active_state, state = self.extract_states_from_transfer_contract contract
    if self.active?
      self.add_future_state(state)
    else
      if state.started_on > Date.today
        self.add_future_state(state)
      else
        self.from_state(state)
      end
    end
    current_state = active_state
    started_on = state.finished_on #use to make all the state to join together
    #if any active future state move to the new one
    while( future_state = current_state.future_state)
      if future_state.state_type == MembershipState::TYPES::ACTIVE
        logger.info("move state: '#{future_state}' to membership '#{self.id}'")
        duration = future_state.finished_on - future_state.started_on
        future_state.started_on = started_on
        future_state.finished_on = started_on + duration
        future_state.membership = self
        self.add_future_state(future_state)

        started_on = future_state.finished_on
      else #remove any none-active states
        future_state.destroy
        logger.info("remove state: '#{future_state}'")
      end
      current_state = future_state
    end
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
    if self.finished_on && self.finished_on < Date.today
      if( future_state = self.current_state.future_state)
        future_state.membership = self #avoid infinite invoking on after_find
        self.from_state( future_state)
      else
        if self.active?
          self.expire
        elsif self.suspended?
          self.resume
        else
          self.finished_on = nil
        end
      end
      self.save
    end
  end

  def has_future_state?
    self.current_state && self.current_state.future_state
  end

  def create_initialize_state
    state = MembershipState.new
    state.state_type = MembershipState::TYPES::EXPIRED
    state.started_on = Date.today
    self.new_state state
  end

  protected

  def to_state
    state = MembershipState.new
    state.state_type = self.status
    state.contract_id = self.contract_id
    [:started_on, :finished_on, :type_id, :contract_id].each do |method|
      if state.respond_to? method
        state.send(:"#{method}=", self.send(:"#{method}"))
      end
    end
    state
  end

  def from_state state
    if !state.membership
      state.membership = self
    elsif state.membership != self
      raise "trying to add a state belongs to another membership( id: #{state.membership.id} to the membership( id: #{self.id})"
    end
    self.status = state.state_type
    [:started_on, :finished_on, :type_id, :contract_id].each do |method|
      if state.respond_to? method
        self.send(:"#{method}=", state.send(:"#{method}"))
      else
        self.send(:"#{method}=", nil)
      end
    end
    last_state = self.current_state
    state.last_state = last_state
    state.save
    self.current_state = state
    state
  end

  protected
  def new_state state
    if !state.membership
      state.membership = self
    elsif state.membership != self
      raise "trying to add a state belongs to another membership( id: #{state.membership.id} to the membership( id: #{self.id})"
    end
    previous_state = self.current_state
    self.current_state = state
    [:started_on, :finished_on, :type_id, :contract_id].each do |method|
      if self.current_state.respond_to? method
        self.send(:"#{method}=", self.current_state.send(:"#{method}"))
      else
        self.send(:"#{method}=", nil)
      end
    end
    state.last_state = previous_state
    state.membership = self
    state.save
  end

  def add_future_state state
    if !state.membership
      state.membership = self
    elsif state.membership != self
      raise "trying to add a state belongs to another membership( id: #{state.membership.id} to the membership( id: #{self.id})"
    end
    current_state = self.current_state
    preceding_state = current_state.lastest_future_state
    # if the state will not start on the date the preceding state will be finished
    # add an extra expired state between the two states
    if preceding_state.finished_on < state.started_on
      expire_state = MembershipState.new
      expire_state.state_type = MembershipState::TYPES::EXPIRED
      expire_state.started_on = preceding_state.finished_on
      expire_state.finished_on = state.started_on
      preceding_state = self.add_future_state expire_state
    end
    state.last_state = preceding_state
    state.save
    preceding_state.future_state = state
    preceding_state.save
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
    self.save
  end

  def extract_state_from_renew_contract contract
    state = MembershipState.new
    state.state_type = MembershipState::TYPES::ACTIVE
    state.contract_id = contract.contract_id
    state.started_on = contract.started_on
    state.finished_on = contract.finished_on
    state.type_id = contract.type_id
    state
  end

  def extract_states_from_transfer_contract contract
    source_account = contract.account
    current_state = source_account.membership.current_state
    active_state = current_state
    if active_state.state_type != MembershipState::TYPES::ACTIVE
      while( future_state = active_state.future_state) && future_state.state_type != MembershipSTate::TYPES::ACTIVE
        active_state = future_state
      end
      raise 'no proper active state to transfer' unless active_state
    end
    remaining_days = (active_state.finished_on - active_state.started_on) - (Date.today - active_state.started_on)
    state = MembershipState.new
    state.state_type = MembershipState::TYPES::ACTIVE
    state.contract_id = contract.contract_id
    state.started_on = contract.target_contract_started_on
    state.finished_on = contract.target_contract_started_on + remaining_days
    state.type_id = active_state.type_id
    return active_state, state
  end
end
