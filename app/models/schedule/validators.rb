module Schedule::Validators
  class SlotsConflictValidator < ActiveModel::Validator
    def validate(record)
      record.slots.reduce([]) do |slots, slot|
        slots.each do |previous|
          record.errors.add(:slots, :conflict_slots, :target => previous.to_s, :source => slot)
        end
      end
    end
  end
end