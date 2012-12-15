class Participation < ActiveRecord::Base
  include Assignable
  belongs_to :account
  belongs_to :lesson
  belongs_to :trainer, :class_name => "User"
  attr_accessible :account_id, :lesson_id, :trainer_id, :times

  validates_presence_of :account_id, :lesson_id, :trainer_id

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
