AccountsController.class_eval do
  helper :leads

  def renew
    @account = Account.find(params[:id])
    @contract = Contracts::MembershipContract.find_or_create_by_account_id_and_signed_at(@account.id, nil)
  end

  def do_renew
    @account = Account.find(params[:id])
    @contract = Contracts::MembershipContract.find_or_create_by_account_id_and_signed_at(@account.id, nil)
    @contract.update_attributes(params[:contracts_membership_contract])
    respond_with(@account)
  end

  def transfer
    @account = Account.find(params[:id])
    membership = @account.membership
    membership.contract_id = nil
    @membership_state = MembershipState.new :state_type => MembershipState::TYPES::TRANSFERRED
    respond_with(@account)
  end

  def do_transfer
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

  def do_suspend
    @account = Account.find(params[:id])
    @membership_state = @account.membership.suspend params[:account]
    respond_with(@account)
  end

  def resume
    @account = Account.find(params[:id])
    @account.membership.resume
  end

  def edit_membership_state
    @account = Account.find(params[:id])
    @contract_type = params[:contract]
    case @contract_type
      when 'renew'
        @contract = Contracts::MembershipContract.find_or_initialize_by_account_id_and_signed_at(@account.id, nil)
      when 'suspend'
        @contract = Contracts::MembershipSuspendContract.find_or_initialize_by_account_id_and_signed_at(@account.id, nil)
      when 'transfer'
        @contract = Contracts::MembershipTransferContract.find_or_initialize_by_account_id_and_signed_at(@account.id, nil)
    end
  end

  def update_membership_state
    edit_membership_state
    @contract.update_attributes(params[:"contracts_#{@contract.type_name}"])
  end

  def new_participation
    @account = Account.find(params[:id])
    @contract = Contracts::LessonContract.find_or_initialize_by_account_id_and_signed_at(@account.id, nil)
  end

  def update_participation
    @account = Account.find(params[:id])
    @contract = Contracts::LessonContract.find_or_initialize_by_account_id_and_signed_at(@account.id, nil)
    @contract.update_attributes(params[:contracts_lesson_contract])
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

  def filter
    session[:accounts_filter] = params[:states]
    @accounts = get_accounts(:page => 1)
    render :index
  end

  def new_survey
    @account = Account.find(params[:id])
    @surveys = Survey.all
  end

  def survey
    @account = Account.find(params[:id])
    @survey = Survey.find(params[:account_survey][:survey_id])
    @response_set = ResponseSet.create(:survey => @survey )
    @account_survey = AccountSurvey.create(:survey => @survey, :account => @account, :response_set => @response_set)
  end

  def new_locker
    @account = Account.find(params[:id])
    @contract = Contracts::LockerContract.find_or_initialize_by_account_id_and_signed_at(@account.id, nil)
  end

  def create_locker
    @account = Account.find(params[:id])
    @contract = Contracts::LockerContract.find_or_create_by_account_id_and_signed_at(@account.id, nil)
    @contract.update_attributes(params[:contracts_locker_contract])
    respond_with(@account)
  end

  private
  def get_data_for_sidebar
    @account_state_total = Hash[
        Setting[:account_status].map do |key|
          [key, Account.my.joins(:membership).where(['`memberships`.`status` = ?', key]).count]
        end
    ]
    categorized = @account_state_total.values.sum
    @account_state_total[:all] = Account.my.count
    #@account_state_total[:other] = @account_state_total[:all] - categorized
  end
end