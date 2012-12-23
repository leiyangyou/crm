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

  def account_state_checkbox(state, count)
    checked = (session[:account_filter] ? session[:account_filter].split(',').include?(state) : count.to_i > 0)
    onclick = remote_function(
        :url => {:action => :filter},
        :with => h(%Q/"states=" + $$("input[name='states[]']").findAll(function(el){ return el.checked}).pluck("value")/),
        :loading => "$('loading').show()",
        :complete => "$('loading').hide()"
    )
    check_box_tag("states[]", state, checked, :id => state, :onclick => onclick)
  end
end