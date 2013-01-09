module Contracts
  class LockerContract < Contract
    serialize_attributes do
      string :identifier, :required => true
      float :deposit
      float :rent
      float :amount
      float :amount_paid
      float :amount_owing
    end

    def locker
      @locker ||= Locker.find_by_identifier(self.identifier)
    end

    def generate_abstract
      self.abstract = identifier
    end

    def contract_type
      :locker
    end

    def signed
      locker = self.locker
      account = self.account
      locker_rent = LockerRent.new
      binding.pry
      locker_rent.started_on = self.started_on
      locker_rent.finished_on = self.finished_on
      locker_rent.locker = locker
      locker_rent.account = account
      locker_rent.rent
      self.save if locker_rent.save
    end
  end
end