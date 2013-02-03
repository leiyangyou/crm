class Participation < ActiveRecord::Base
  include Assignable
  belongs_to :account
  belongs_to :lesson
  belongs_to :trainer, :class_name => "User"
  belongs_to :contract
  attr_accessible :account_id, :lesson_id, :trainer_id, :times

  validates_presence_of :account_id, :lesson_id, :trainer_id

  state_machine :status, :initial => :normal do
    event :transfer do
      transition :normal => :transferred
    end
  end

  default_scope do
    order('created_at DESC')
  end

  scope :normal, where(:status => "normal")


  def self.from_contract contract
  end

  def assignable_value
    self.lesson.try(:price){0}
  end

  def attend
    if self.times > 0
      self.times -= 1
      self.save
      true
    else
      false
    end
  end
end
