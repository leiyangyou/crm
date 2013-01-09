module Contracts
  class MembershipTransferContract < Contract
    serialize_attributes do
      integer :target_id, :required => true
      float :transfer_fee
      string :card_number
      date :source_contract_finished_on
      date :target_contract_started_on
    end

    validates_presence_of :target_id, :transfer_fee, :card_number, :source_contract_finished_on, :target_contract_started_on

    #validates the existence of target account
    validates_each :target_id do |record, attr, value|
      record.errors.add(attr, :cannot_find_target, :target_id => value) unless Account.find_by_id(value)
    end

    #validates the finished on is in proper range
    validates_each :source_contract_finished_on do |record, attr, value|
      record.errors.add(attr, :out_of_range, :finished_on => record.account.membership.finished_on ) unless record.account.membership.finished_on >= value
    end

    before_validation {
      unless self.signed? || !self.account
        fill_derived_fields
      end
    }

    def target
      @target ||= Account.find_by_id(target_id)
    end

    def target_name
      target && target.name
    end

    def signed
      self.account.membership.transfer self
    end

    protected
    def fill_derived_fields
      self.started_on = self.source_contract_finished_on
      self.finished_on = self.target_contract_started_on
    end
  end
end