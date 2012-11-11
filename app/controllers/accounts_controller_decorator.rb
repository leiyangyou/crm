AccountsController.class_eval do

  def renewal
    @account = Account.find(params[:id])
    @membership = @account.membership || Membership.new
  end
  def promote_renewal
    @account = Account.find(params[:id])
    @membership = @account.create_or_update_membership(params[:account][:membership])
    @membership.renewal
    if @membership.contract_id
      @membership.activate
    end
    @membership.save
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
    @membership = @account.membership || Membership.new
    @membership_suspension = MembershipSuspension.new
    @membership_suspension.membership = @membership
    respond_with(@account)
  end

  def promote_suspend
    @account = Account.find(params[:id])
    @membership = @account.membership
    @membership_suspension = @membership.create_suspension(params[:account][:membership_suspension])
    respond_with(@account)
  end

  def continue
    @account = Account.find(params[:id])
    if @account.suspended?
      @account.membership.continue_membership
    end
  end
end