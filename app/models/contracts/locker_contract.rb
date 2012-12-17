module Contracts
  class LockerContract < Contract
    parameter_fields do
      string :identifier, :required => true
      date :start_date, :required => true
      date :due_date, :required => true
    end

    def locker
      @locker ||= Locker.find_by_identifier(self.identifier)
    end

    def generate_abstract
      self.abstract = identifier
    end

    def signed
      locker = self.locker
      account = self.account
      locker_rent = LockerRender.new
      locker_rent.start_date = self.start_date
      locker_rent.due_date = self.due_date
      locker_rent.locker = locker
      locker_rent.account = account
      self.save if locker_rent.save
    end
  end
end