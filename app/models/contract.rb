class Contract < ActiveRecord::Base
  belongs_to :contract_type
  attr_accessible :content, :contract_id, :contract_template, :end_at, :parameters, :signed_at, :start_at, :state
end
