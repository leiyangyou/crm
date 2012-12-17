module Assignable

  def self.included base
    base.class_eval do
      has_one :assignment, :as => :assignable
      has_one :assigner, :through =>:assignment, :source => :user
      accepts_nested_attributes_for :assignment
      attr_accessible :assignment_attributes
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
    def assigned_by assigner
      return if self.assigner
      assigner_id = case assigner
                      when User then assigner.id
                      when Integer then assigner
                    end
      assignment = Assignment.new
      assignment.user_id = assigner_id
      self.assignment = assignment
    end
    def assignable_value
      0
    end
  end
end