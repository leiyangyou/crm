module Contracts
  class LessonContract < Contract

    belongs_to :lesson
    belongs_to :trainer, :class_name => "User", :foreign_key => :trainer_id
    validates_presence_of :lesson, :trainer

    serialize_attributes do
      integer :lesson_id, :required => true
      integer :tuition_fee, :required => true
      integer :trainer_id, :required => true
    end

    def lesson_name
      lesson && lesson.name
    end

    def trainer_name
      trainer && trainer.name
    end

    def contract_type
      :lesson
    end

    def generate_abstract
      self.abstract = [lesson_name, trainer_name].compact.join(",")
    end

    def signed
      lesson = self.lesson
      account = self.account
      trainer = self.trainer
      participation = Participation.new
      participation.account = account
      participation.lesson = lesson
      participation.times = lesson.times
      participation.trainer = trainer
      participation.assigned_by self.trainer
      participation.contract_id = self.contract_id
      self.save if participation.save
    end
  end
end