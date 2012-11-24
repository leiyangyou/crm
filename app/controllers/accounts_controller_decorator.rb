AccountsController.class_eval do

  def renewal
    @account = Account.find(params[:id])
    @membership_state = MembershipState.new :state_type => MembershipState::TYPES::ACTIVE
  end

  def promote_renewal
    @account = Account.find(params[:id])
    @membership_state = @account.membership.renewal params[:account]
    respond_with(@account)
  end

  def sign_contract
  end

  def promote_sign_contract
  end

  def transfer
    @account = Account.find(params[:id])
    membership = @account.membership
    membership.contract_id = nil
    @membership_state = MembershipState.new :state_type => MembershipState::TYPES::TRANSFERRED
    respond_with(@account)
  end

  def promote_transfer
    @account = Account.find(params[:id])
    @membership_state = @account.membership.transfer params[:account]
    @target_account = Membership.find(@membership_state.target_id).account
    respond_with(@account)
  end

  def suspend
    @account = Account.find(params[:id])
    membership = @account.membership
    membership.contract_id = nil
    membership.started_on = Date.today
    @membership_state = MembershipState.new :state_type => MembershipState::TYPES::SUSPENDED
    respond_with(@account)
  end

  def promote_suspend
    @account = Account.find(params[:id])
    @membership_state = @account.membership.suspend params[:account]
    respond_with(@account)
  end

  def resume
    @account = Account.find(params[:id])
    @account.membership.resume params[:account]
  end
end