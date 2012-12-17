module Contracts
  class MembershipTransferContract < Contract
    parameter_fields do
      number :target_id, :required => true
    end

    def target
      @target ||= Account.find_by_id(target_id)
    end

    def target_name
      target && target.name
    end

    def signed
      self.account.membership.transfer self
    end
  end
end