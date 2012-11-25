class Lesson < ActiveRecord::Base
  attr_accessible :name, :description, :price, :times

  validates_presence_of :name, :description, :price, :times
end
