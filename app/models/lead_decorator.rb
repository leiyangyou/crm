Lead.class_eval do
  scope :text_search, lambda { |query|
    query = query.gsub(/[^\w\s\-\.'\p{L}]/u, '').strip
    where('upper(first_name) LIKE upper(:s) OR upper(last_name) LIKE upper(:s) OR upper(phone) LIKE upper(:s) OR upper(mobile) LIKE upper(:s)', :s => "#{query}%", :m => "%#{query}%")
  }

  def promote params
    account     = Account.create_or_select_for(self, params[:account], params[:users])
    opportunity = Opportunity.create_for(self, account, params[:opportunity], params[:users])
    contact     = Contact.create_for(self, account, opportunity, params)
    membership = Membership.create_or_select_for(account, params[:membership])

    [account, opportunity, contact, membership]
  end
end