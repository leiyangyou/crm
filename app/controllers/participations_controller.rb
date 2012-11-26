class ParticipationsController < ApplicationController

  def destroy
    @participation = Participation.find(params[:id])
    @participation.destroy
  end

  def attend
    @participation = Participation.find(params[:id])
    respond_with(@participation) do
      unless @participation.attend
        flash[:warning] = "No more times is available"
      end
    end
  end
end
