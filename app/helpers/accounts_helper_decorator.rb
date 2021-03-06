AccountsHelper.class_eval do
  def trainers
    @trainers ||= User.active.trainers.ranked("trainer")
  end

  def assignable_trainers
    @assignable_trainers ||= if can?(:assign_any_trainer, @account)
      trainers
    elsif can?(:assign_self_as_a_trainer, @account)
      [@current_user]
    end
  end

  def link_to_renew model
    name = (params[:klass_name] || model.class.name).underscore.downcase
    link_to(t(:renew),
            params[:url] || send(:"renew_#{name}_path", model),
            :remote  => true,
            :onclick => "this.href = this.href.split('?')[0] + '?previous='+crm.find_form('edit_#{name}');"
    )
  end

  def link_to_suspend account
    #link_to( t(:suspend), new_account_contract_path(account, :contract_type => Contracts::MembershipSuspensionContract.to_s),
    #         :target => "_blank"
    #)
  end

  def link_to_transfer account
    #link_to( t(:transfer), new_account_contract_path(account, :contract_type => Contracts::MembershipTransferContract.to_s),
    #         :target => "_blank"
    #)
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