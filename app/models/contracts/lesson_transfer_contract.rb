class Contracts::LessonTransferContract < Contract

  serialize_attributes :data, :blob => :parameters do
    integer :participation_id
    integer :lesson_id
    integer :target_id
    integer :trainer_id
    integer :times
    float :transfer_fee
  end

  belongs_to :participation
  belongs_to :lesson
  belongs_to :target, :class_name => "Account", :foreign_key => :target_id
  belongs_to :trainer, :class_name => "User", :foreign_key => :trainer_id

  def signed
    lesson = self.lesson
    account = self.account
    trainer = self.trainer
    participation = Participation.new
    participation.account = account
    participation.lesson = lesson
    participation.times = lesson.times
    participation.trainer = trainer
    participation.times = self.times
    participation.contract_id = self.contract_id
    self.participation.transfer
  end
end
