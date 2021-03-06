Lead.class_eval do
  has_one :account
  has_many :account_surveys, :as => :respondent

  belongs_to :consultant, :foreign_key => :assigned_to, :class_name => "User"

  after_update :transfer_mc_related_stuff_if_necessary

  after_create :create_task_for_consultant

  before_save :record_mc_changed_if_necessary

  validates_presence_of :assigned_to

  before_save lambda {|record|
    record.mc_modified_at = Time.now unless record.mc_modified_at
  }

  scope :text_search, lambda { |query|
    query = query.gsub(/[^\w\s\-\.'\p{L}]/u, '').strip
    where('upper(first_name) LIKE upper(:s) OR upper(last_name) LIKE upper(:s) OR upper(phone) LIKE upper(:s) OR upper(mobile) LIKE upper(:s)', :s => "#{query}%", :m => "%#{query}%")
  }

  def promote params
    account     = Account.create_or_select_for(self, params[:account], params[:users])
    contract = Contracts::MembershipContract.create_for(account, params[:contracts_membership_contract])
    account_surveys.map do |as|
      AccountSurvey.create(:survey => as.survey, :respondent => account, :response_set => as.response_set)
    end

    [account, contract]
  end

  after_save do
    unless ["converted", "rejected"].include?(self.status)
      related_tasks = self.tasks.pending.related_to_user(self.assignee).where("assigned_to != ?", self.assigned_to)
    end
  end

  private
  def transfer_mc_related_stuff_if_necessary
    if self.assigned_to_changed?
      self.tasks.pending.where(:assigned_to => self.assigned_to_was).update_all(:assigned_to => self.assigned_to)
    end
  end

  def create_task_for_consultant
    if (consultant = self.consultant)
      Task.create!(
        :user_id => consultant.id,
        :assigned_to => consultant.id,
        :name => I18n.t("model.lead.task.new_lead"),
        :bucket => "due_asap",
        :due_at => nil,
        :asset => self,
        :category => "follow_up"
      )
    end
  end

  def record_mc_changed_if_necessary
    if self.assigned_to_changed?
      self.mc_modified_at = Time.now
    end
  end
end