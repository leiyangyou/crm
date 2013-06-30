class ParticipationsController < ApplicationController

  def destroy
    @participation = Participation.find(params[:id])
    @participation.destroy
  end

  def attend
    @participation = Participation.find(params[:id])
    respond_with(@participation) do
      unless @participation.attend current_user
        flash[:warning] = "No more times is available"
      end
    end
  end

  def new_lesson_transfer
    @participation = Participation.find(params[:id])
    @account = @participation.account
    @lesson = @participation.lesson
    @contract = Contracts::LessonTransferContract.find_or_initialize_by_account_id_and_signed_at(@account.id, nil)
    @contract.account = @account
    @contract.lesson_id = @lesson.id
    @contract.trainer_id = @participation.trainer_id
    @contract.participation_id = @participation.id
    @contract.started_on = Date.today
    @contract.finished_on = Date.today
  end

  def update_lesson_transfer
    new_lesson_transfer
    @contract.update_attributes(params[:contracts_lesson_transfer_contract])
  end
end
