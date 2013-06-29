LeadsController.class_eval do
  def convert
    address = @lead.business_address

    @account = @lead.build_account(
      :user => @current_user,
      :first_name => @lead.first_name,
      :last_name => @lead.last_name,
      :name => @lead.full_name,
      :gender => @lead.gender,
      :access => "Lead",
      :assigned_to => @lead.assigned_to,
      :phone => @lead.mobile,
      :email => @lead.email,
      :street1 => address.street1,
      :street2 => address.street2,
      :zipcode => address.zipcode,
    )

    @contract = Contracts::MembershipContract.new
    @contract.account_id = @account.id

    if params[:previous].to_s =~ /(\d+)\z/
      @previous = Lead.my.find_by_id($1) || $1.to_i
    end

    respond_with(@lead)
  end

  def promote
    error_free = false

    ActiveRecord::Base.transaction do
      @account, @contract= @lead.promote(params)
      error_free = @account.errors.empty? && @contract.errors.empty?
      raise ActiveRecord::Rollback unless error_free
      @lead.account_surveys.each do |account_survey|
        account_survey.respondent = @account
        account_survey.save
      end
    end

    respond_with(@lead) do |format|
      if error_free
        @lead.convert
        update_sidebar
      else
        errors = @account.errors.to_a + @contract.errors.to_a
        format.json { render :json => errors, :status => :unprocessable_entity }
        format.xml  { render :xml => errors, :status => :unprocessable_entity }
      end
    end
  end

  def new_survey
    @lead = Lead.find(params[:id])
    @surveys = Survey.all
  end

  def survey
    @lead = Lead.find(params[:id])
    @survey = Survey.find(params[:account_survey][:survey_id])
    @response_set = ResponseSet.create(:survey => @survey )
    @account_survey = AccountSurvey.create(:survey => @survey, :respondent => @lead, :response_set => @response_set)
  end
end