module Contracts
  class MembershipSuspendContract < Contract
    parameter_fields do
      date :started_on, :required => true
      date :finished_on, :required => true
    end

    def signed
      membership = account.membership
      membership.renewal self
    end
  end
end