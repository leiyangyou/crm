module Contracts
  class MembershipSuspendContract < Contract
    serialize_attributes do
      time :started_on, :required => true
      time :finished_on, :required => true
    end

    def signed
      membership = account.membership
      membership.renewal self
    end
  end
end