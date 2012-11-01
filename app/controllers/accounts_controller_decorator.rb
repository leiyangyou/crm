AccountsController.class_eval do

  def renewal
    @account = Account.find(params[:id])
    @membership = @account.membership || Membership.new
  end
  def promote_renewal
    @account = Account.find(params[:id])
    @membership = @account.create_or_update_membership(params[:account][:membership])
    @membership.renewal
    @membership.save
    respond_with(@account)
  end

  def transfer
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
    @membership_suspension = @membership.create_suspension(params[:membership_suspension])
    respond_with(@account)
  end
end