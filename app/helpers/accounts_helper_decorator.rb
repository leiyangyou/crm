AccountsHelper.class_eval do
  def link_to_renewal account
    link_to( t(:renewal), new_account_contract_path(account, :contract_type => Contracts::MembershipContract.to_s),
             :target => "_blank"
    )
  end
  def link_to_suspend account
    link_to( t(:suspend), new_account_contract_path(account, :contract_type => Contracts::MembershipSuspensionContract.to_s),
             :target => "_blank"
    )
  end

  def link_to_transfer account
    link_to( t(:transfer), new_account_contract_path(account, :contract_type => Contracts::MembershipTransferContract.to_s),
             :target => "_blank"
    )
  end

  def link_to_resume account
  end
end