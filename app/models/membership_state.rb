module MembershipStateDecorator
end

class MembershipState < ActiveRecord::Base
  include MembershipStateDecorator::ParametersHelper
  include Assignable
  module TYPES
    ACTIVE = "active"
    PENDING = "pending"
    EXPIRED = "expired"
    SUSPENDED = "suspended"
    TRANSFERRED = "transferred"
    TERMINATED = "terminated"
    ALL = [ACTIVE, EXPIRED, SUSPENDED, TRANSFERRED, TERMINATED]
  end
  belongs_to :membership
  belongs_to :last_state, :class_name => "MembershipState", :foreign_key => :last_state_id
  belongs_to :future_state, :class_name => "MembershipState", :foreign_key => :future_state_id
  attr_accessible :contract_id, :state_type, :parameters_attributes
  validates_presence_of :membership_id
  validates_presence_of :state_type
  validates_inclusion_of :state_type, :in => TYPES::ALL
  validates_with MembershipStateDecorator::ParametersValidator

  serialize :parameters, Hash

  type TYPES::ACTIVE do
    parameter :type_id, Integer
  end

  type TYPES::EXPIRED do
  end

  type TYPES::PENDING do
  end

  type TYPES::SUSPENDED do
    parameter :type_id, Integer
    parameter :remaining_days, Integer, :required => false
  end

  type TYPES::TRANSFERRED do
    parameter :target_id, Integer
  end

  type TYPES::TERMINATED do
    parameter :reason, String
  end

  def assignable_value
    if self.respond_to?(:type_id)
      MembershipType.find_by_id(self.type_id).try(:price) || 0
    else
      0
    end
  end

  def parameters_attributes= new_attributes
    assign_parameters_attributes new_attributes
  end

  def find_last_state type = nil
    return self.last_state unless type
    current_state = self.last_state
    while current_state && current_state.state_type != type
      current_state = current_state.last_state
    end
    current_state
  end

  def lastest_future_state
    current_state = self
    while(future_state = current_state.future_state)
      current_state = future_state
    end
    current_state
  end

  def respond_to? method, include_private = false
    return true if super
    if method.to_s.end_with?("=")
      method = method[0..-2]
    end
    self.valid_parameter? method
  end

  def method_missing(method, *args, &block)
    if method.to_s.end_with?("=")
      method = method[0..-2]
      if self.valid_parameter? method
        return assign_parameters_attributes :"#{method}" => args.first
      end
    elsif self.valid_parameter? method
      return parameters[method.to_s]
    end
    super
  end
end
