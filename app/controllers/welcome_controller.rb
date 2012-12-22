class WelcomeController < ApplicationController

  layout false

  def index
  end

  def show
    @account = Account.find_by_name(params[:id])
    @account.account_visits << AccountVisit.new if @account
  end

end
