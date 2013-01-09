class WelcomeController < ApplicationController

  layout false

  def index
  end

  def show
    @account = Account.text_search(params[:id]).first
    @account.account_visits << AccountVisit.new if @account
  end

end
