module Assignable

  def self.included base
    base.class_eval do
      has_one :assignment, :as => :assignable
      has_one :assigner, :through =>:assignment, :source => :user
      accepts_nested_attributes_for :assignment
    end
    unless base.kind_of? Assignment
      base.send(:include, InstanceMethods)
      add_assignable base
    end
  end

  def self.add_assignable assignable
    self.assignables << assignable
  end

  def self.assignables
    @assignables ||= []
  end

  module InstanceMethods
    def assignable_value
      0
    end
  end
end