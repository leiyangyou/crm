AccountsController.class_eval do

  def renewal
    @users = User.consultants.except(@current_user).ordered
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

  def new_participation
    @account = Account.find(params[:id])
    @participation = Participation.new
    @participation.account = @account
  end

  def participate
    @account = Account.find(params[:id])
    @participation = @account.participate_lesson(params[:account])
  end

  def delete_participation
    @account = Account.find(params[:id])
    @lesson = Lesson.find(params[:lesson_id])
    @participation = Participation.find_by_account_id_and_lesson_id(@account.id, @lesson.id)
    @participation.detroy
  end
end