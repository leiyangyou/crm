Lead.class_eval do
  has_one :account

  scope :text_search, lambda { |query|
    query = query.gsub(/[^\w\s\-\.'\p{L}]/u, '').strip
    where('upper(first_name) LIKE upper(:s) OR upper(last_name) LIKE upper(:s) OR upper(phone) LIKE upper(:s) OR upper(mobile) LIKE upper(:s)', :s => "#{query}%", :m => "%#{query}%")
  }

  def promote params
    account     = Account.create_or_select_for(self, params[:account], params[:users])
    contract = Contracts::MembershipContract.create_for(account, params[:contracts_membership_contract])

    [account, contract]
  end
end