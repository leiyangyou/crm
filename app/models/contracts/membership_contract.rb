module Contracts
  class MembershipContract < Contract
    parameter_fields do
      number :consultant_id, :required => true
      number :assigner_id, :required => true
      number :type_id, :required => true
    end

    def consultant
      @consultant ||= User.find_by_id(consultant_id)
    end

    def consultant_name
      consultant && consultant.name
    end

    def assigner
      @assigner ||= User.find_by_id(assigner_id)
    end

    def membership_type
      @membership_type ||= MembershipType.find_by_id(type_id)
    end

    def membership_type_name
      membership_type && membership_type.name
    end

    def singed
      account.membership.renewal self
    end
  end
end