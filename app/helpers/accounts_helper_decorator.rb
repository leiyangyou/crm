AccountsHelper.class_eval do
  def link_to_renewal account
    link_to( t(:renewal), renewal_account_path(account),
        :method => :get,
        :remote => true
    )
  end
end