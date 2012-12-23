class Participation < ActiveRecord::Base
  include Assignable
  belongs_to :account
  belongs_to :lesson
  belongs_to :trainer, :class_name => "User"
  attr_accessible :account_id, :lesson_id, :trainer_id, :times

  validates_presence_of :account_id, :lesson_id, :trainer_id

  default_scope do
    order('created_at DESC')
  end


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
