LeadsController.class_eval do

  def convert
    @users = User.except(@current_user)
    @account = Account.new(:user => @current_user, :name => @lead.company, :access => "Lead")
    @accounts = Account.my.order('name')
    @opportunity = Opportunity.new(:user => @current_user, :access => "Lead", :stage => "prospecting", :campaign => @lead.campaign, :source => @lead.source)
    @membership = Membership.new

    if params[:previous].to_s =~ /(\d+)\z/
      @previous = Lead.my.find_by_id($1) || $1.to_i
    end

    respond_with(@lead)
  end
end