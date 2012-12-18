LeadsController.class_eval do
  before_filter :load_consultants, :only => [:new, :edit, :convert, :promote]
  before_filter :load_assignable_consultants, :only => [:new, :edit, :convert, :promote]

  def convert
    @account = Account.new(
      :user => @current_user,
      :name => @lead.full_name,
      :access => "Lead",
      :assigned_to => @lead.assigned_to
    )

    address = @lead.business_address

    @contract = Contracts::MembershipContract.new(
      :gender => @lead.gender,
      :phone => @lead.mobile,
      :email => @lead.email,
      :street1 => address.street1,
      :street2 => address.street2,
      :zipcode => address.zipcode
    )

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

  protected
  def load_consultants
    @consultants ||= User.active.consultants.ranked("consultant")
  end

  def load_assignable_consultants
    @assignable_consultants ||= if can?(:assign_any_consultant, @lead)
      @consultants
    elsif can?(:assign_self, @lead)
      [@current_user]
    end
  end
end