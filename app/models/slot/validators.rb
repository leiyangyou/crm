module Slot::Validators
  class TimeValidator < ActiveModel::Validator
    def validate(record)
      unless record.start_time < record.end_time
        record.errors.add(:start_time, :should_be_before_end_time)
      end
    end
  end

  class ConflictValidator < ActiveModel::Validator
    def validate(record)
      record.schedule.slots.each do |slot|
        if record != slot && record.intersects_with?( slot)
          record.errors.add(:base, :conflict_slot, :source)
        end
      end
    end
  end
end