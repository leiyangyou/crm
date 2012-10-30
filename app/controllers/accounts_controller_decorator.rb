AccountsController.class_eval do

  def renewal
    @account = Account.find(params[:id])
    @membership = @account.membership || Membership.new
  end
  def promote_renewal
    @account = Account.find(params[:id])
    @membership = @account.create_or_update_membership(params[:account][:membership])
    @membership.renewal
    respond_with(@account)
  end

  def transfer
  end

  def suspend
    @account = Account.find(params[:id])
    @membership = @account.membership || Membership.new
    respond_with(@account)
  end

  def promote_suspend
    @account = Account.find(params[:id])
    @membership = @account.membership
    @membership.suspend(params[:membership_suspension])
    respond_with(@account)
  end
end