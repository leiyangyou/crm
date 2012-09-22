module Slot::Validators
  class TimeValidator < ActiveModel::Validator
    def validate(record)
      unless record.begin_time < record.end_time
        record.errors.add(:begin_time, :should_before_end_time)
      end
    end
  end
end