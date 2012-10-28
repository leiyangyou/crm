Lead.class_eval do
  def promote
    account     = Account.create_or_select_for(self, params[:account], params[:users])
    opportunity = Opportunity.create_for(self, account, params[:opportunity], params[:users])
    contact     = Contact.create_for(self, account, opportunity, params)
    membership = Membership.create_or_select_for(account, params[:membership])

    [account, opportunity, contact, membership]
  end
end