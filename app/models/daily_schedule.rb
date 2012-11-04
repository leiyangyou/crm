#
# each bit in the working_time represents a slot on the time table,
# a slot takes 30min
# for example:
# 281474976710655 => 111111111111111111111111111111111111111111111111 => work all day long
# 137438887936    => 000000000001111111111111111111110000000000000000 => 8 a.m. - 18:30 p.m.

class DailySchedule < ActiveRecord::Base
  belongs_to :schedule
  attr_accessible :date, :slots, :working_time

  def available? time_range
    (time_range.compact ^ self.working_time) == time_range.compact
  end

  def readable_working_time
    Utils.loosen(self.working_time)
  end

  class TimeRange
    def initialize start_time, end_time
      @start_index = TimeRange.index_of(start_time)
      @end_index = TimeRange.index_of(end_time)
    end

    # get the index in the slots for specified time
    def self.index_of time_str
      sections = time_str.split(":")
      index = sections[0].to_i * 2
      index += 1 if sections[1] && sections[1].to_i >= 30
      index
    end

    def compact
      @compact ||= ((1 << @end_index) - 1) ^ ((1 << @start_index) - 1)
    end
  end
  module Utils
    class << self
      def compact *times
        times.reduce(0) do |result,time|
          binary = case time
                     when /(\d+(?:\:\d+)?)-(\d+(?:\:\d+)?)/
              TimeRange.new($1, $2).compact
                     when /(\d+)/
              TimeRange.new($1.to_s, "#{($1.to_i + 1) % 24}:00").compact
                   end
          result |= binary
          result
        end
      end
      def loosen working_time
        ranges = []
        start_time = nil
        mask = 1
        49.times do |i|
          if working_time & mask > 0
            unless start_time
              start_time = Utils.index_to_readable(i)
            end
          else
            if start_time
              end_time = Utils.index_to_readable(i)
              ranges << "#{start_time}-#{end_time}"
              start_time = nil
            end
          end
          mask = mask << 1
        end
        ranges.join(",")
      end
      def index_to_readable index
        hour = index / 2
        minute = index % 2 > 0 ? '30' : '00'
        "#{hour}:#{minute}"
      end
    end
  end
end
