class WelcomeController < ApplicationController

  layout false

  def index
  end

  def show
    @account = Account.find_by_name(params[:id])
  end

end
