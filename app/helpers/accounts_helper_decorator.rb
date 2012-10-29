AccountsHelper.class_eval do
  def link_to_renewal account
    link_to( t(:renewal), renewal_account_path(account),
      :method => :get,
      :remote => true
    )
  end
  def link_to_suspend account
    link_to( t(:suspend), suspend_account_path(account),
      :method => :get,
      :remote => true
    )
  end

  def link_to_transfer account
    link_to( t(:transfer), transfer_account_path(account),
      :method =>:get,
      :remote =>true
    )
  end
end