module Schedule::Validators
  class SlotsConflictValidator < ActiveModel::Validator
    def validate(record)
      record.slots.reduce([]) do |slots, slot|
        slots.each{|previous|
        }
      end
      unless record.begin_time < record.end_time
        record.errors.add(:begin_time, :should_before_end_time)
      end
    end
  end
end