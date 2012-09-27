class Contract < ActiveRecord::Base
  belongs_to :contract_type
  has_one :contract_suspension
  has_one :contract_transfer
  belongs_to :template, :class_name =>  "ContractTemplate", :foreign_key => :template_id
  attr_accessible :content, :contract_id, :end_at, :parameters, :signed_at, :started_at, :state
  validates_presence_of :content, :contract_id, :end_at, :parameters, :signed_at, :started_at
end
