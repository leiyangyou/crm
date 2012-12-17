class Lesson < ActiveRecord::Base
  has_many :participations
  belongs_to :trainer, :class_name => "User"
  attr_accessible :name, :description, :price, :times, :trainer_id

  validates_presence_of :name, :description, :price, :times
  validate :has_trainer

  protected
  def has_trainer
    unless trainer && trainer.roles.include?(:trainer)
      errors.add(:trainer, :'errors.no_trainer')
    end
  end
end
