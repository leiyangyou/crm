module Contracts
  class LessonContract < Contract
    parameter_fields do
      number :lesson_id, :required => true
      number :trainer_id, :required => true
      number :assigner_id, :required => true
    end

    def lesson_name
      lesson && lesson.name
    end

    def lesson
      @lesson ||= Lesson.find_by_id(self.lesson_id)
    end

    def trainer_name
      trainer && trainer.name
    end

    def trainer
      @trainer ||= User.find_by_id(self.trainer_id)
    end

    def assigner
      @assigner ||= User.find_by_id(self.assigner_id)
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
      participation.assigned_by self.assigner
      self.save if participation.save
    end
  end
end