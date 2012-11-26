class Lesson < ActiveRecord::Base
  has_many :participations
  attr_accessible :name, :description, :price, :times

  validates_presence_of :name, :description, :price, :times
end
