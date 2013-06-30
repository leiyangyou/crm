class ParticipationLog < ActiveRecord::Base
  belongs_to :participation
  belongs_to :trainer, :class_name => "User", :foreign_key => "trainer_id"
  belongs_to :lesson
  belongs_to :operator, :class_name => "User", :foreign_key => "operator_id"
  # attr_accessible :title, :body

  def self.record participation, operator
    self.create(
      :participation => participation,
      :lesson => participation.lesson,
      :trainer => participation.trainer,
      :operator => operator
    )
  end
end
