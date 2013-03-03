module Contracts
  class MembershipSuspendContract < Contract

    def signed
      membership = account.membership
      membership.renew self
    end
  end
end