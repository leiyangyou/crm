module MembershipStateDecorator
end
class MembershipState < ActiveRecord::Base
  include MembershipStateDecorator::ParametersHelper
  module TYPES
    ACTIVE = "active"
    SUSPEND = "suspend"
    TRANSFER = "transfer"
    TERMINATE = "terminate"
  end
  belongs_to :last_state
  attr_accessible :contract_id, :state_type
  validates_presence_of :state_type

  serialize :parameters, Hash
  type TYPES::ACTIVE do
    parameter :started_on, Date
    parameter :finished_on, Date
  end

  type TYPES::SUSPEND do
    parameter :started_on, Date
    parameter :finished_on, Date
  end

  type TYPES::TRANSFER do
    parameter :target_id, Integer
  end

  type TYPES::TERMINATE do
    parameter :reason, String
  end

  def parameters_attributes= new_attributes
    assign_parameters_attributes new_attributes
  end

  def method_missing(method, *args, &block)
    if method.to_s.end_with?("=")
      method = method[0..-2]
      if self.valid_parameter? method
        assign_parameters_attributes :"#{method}" => args.first
      end
    else
      if self.valid_parameter? method
        return parameters[method]
      end
    end
    super
  end
end
