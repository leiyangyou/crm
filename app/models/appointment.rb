class Appointment < ActiveRecord::Base
  belongs_to :daily_schedule
  attr_accessible :content, :date, :finished_at, :started_at, :status

  validates_presence_of :date, :started_at, :finished_at

  state_machine :status, :initial => :normal do
    event :cancel do
      transaction :normal => :canceled
    end
  end
end
