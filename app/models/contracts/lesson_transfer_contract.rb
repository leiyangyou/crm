class Contracts::LessonTransferContract < Contract

  belongs_to :lesson, :foreign_key => :lesson_id
  belongs_to :participation
  belongs_to :target, :class_name => "Account", :foreign_key => :target_id
  belongs_to :trainer, :class_name => "User", :foreign_key => :trainer_id

  serialize_attributes do
    integer :participation_id
    integer :lesson_id
    integer :target_id
    integer :trainer_id
    float :transfer_fee
  end

  def contract_type
    :lesson_transfer
  end

  def signed
    lesson = self.lesson
    trainer = self.trainer
    participation = Participation.new
    participation.account_id = target_id
    participation.lesson_id = lesson.id
    participation.times = self.participation.times
    participation.trainer_id = trainer.id
    participation.contract_id = self.contract_id
    binding.pry
    participation.save
    self.participation.transfer
  end
end
