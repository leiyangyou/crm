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
    @membership = @account.membership || Membership.new
    @membership_transfer = MembershipTransfer.new
    respond_with(@account)
  end

  def promote_transfer
    @account = Account.find(params[:id])
    @membership = @account.membership
    @membership_transfer = @membership.create_transfer(params[:account][:membership_transfer])
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

  def continue
    @account = Account.find(params[:id])
    if @account.suspended?
      @account.membership.continue_membership
    end
  end
end