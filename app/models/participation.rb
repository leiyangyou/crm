class Participation < ActiveRecord::Base
  belongs_to :account
  belongs_to :lesson
  belongs_to :trainer, :class_name => "User"
  attr_accessible :times

  validates_presence_of :account_id, :lesson_id, :trainer_id

end
