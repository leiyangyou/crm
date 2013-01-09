module Contracts
  class MembershipTransferContract < Contract
    serialize_attributes do
      integer :target_id, :required => true
      float :transfer_fee
      string :card_number
      date :original_contract_started_on
      date :transferred_at
      date :original_card_finished_on
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