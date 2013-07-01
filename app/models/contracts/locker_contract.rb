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

    validate :finished_on_not_before_started_on

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
      locker_rent.start_date = self.started_on
      locker_rent.due_date = self.finished_on
      locker_rent.locker = locker
      locker_rent.account = account
      locker.rent
      self.save if locker_rent.save
    end

    private
    def finished_on_not_before_started_on
      errors.add(:finished_on, :should_after_started_on) if finished_on < started_on
    end
  end
end