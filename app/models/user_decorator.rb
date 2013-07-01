User.class_eval do
  ROLES = [:operator,
           :operator_manager,
           :consultant,
           :consultant_manager,
           :trainer,
           :trainer_manager,
           :general_manager,
           :admin] unless defined?(ROLES)

  acts_as_user :roles => ROLES
  attr_protected :roles

  has_many :assignments

  has_one :schedule

  has_one :user_rank

  delegate :rank, :to => :user_rank, :allow_nil => true

  has_many :tasks, :foreign_key => :assigned_to

  after_create :initialize_schedule

  validates_uniqueness_of :card_number, :allow_nil => true
  before_validation lambda {|record| record.card_number = nil if record.card_number.blank?}

  scope :ranked, lambda { |type|
    includes(:user_rank).where("user_ranks.type = ? or user_ranks.type is null", type).order('COALESCE(user_ranks.rank_override, 999999) asc')
  }

  scope :manageable_by, lambda { |user|
    unless user.admin?
      where("#{role_mask_column} & :role_mask > 0 or #{role_mask_column} = 0 or users.id = :user_id", { :role_mask => mask_for(*user.manageable_roles), :user_id => user.id})
    end
  }

  scope :available_between, lambda { |start_time, end_time|
    range = DailySchedule::TimeRange.new(start_time, end_time).compact
    default_range = DailySchedule::Utils.compact(Setting[:default_working_time])
    .joins(:schedule)
    .joins(sanitize_sql_array(["left join daily_schedules on schedules.id = daily_schedules.schedule_id and daily_schedules.date = ?", start_time.to_date]))
    .where("(ifnull(daily_schedules.working_time, ?) & ? = ?)", default_range, range, range)
    .where("((ifnull(daily_schedules.slots, 0) ^ ?) & ? = ?)", range, range, range)
  }

  scope :text_search, lambda { |query|
    query = query.gsub(/[^\w\s\-\.'\p{L}]/u, '').strip
    where('upper(username) LIKE upper(:s) OR upper(first_name) LIKE upper(:s) OR upper(last_name) LIKE upper(:s) OR upper(phone) LIKE upper(:s) OR upper(mobile) LIKE upper(:s)', :s => "#{query}%")
  }
  scope :active, lambda {
    where("suspended_at is null")
  }

  def primary_roles
    Set.new(roles) & Set.new([:trainer, :consultant])
  end

  def full_description
    now = Time.now
    "#{full_name}#{' - ' + I18n.t(:not_available) unless available_between?(now, now + 30.minutes)}"
  end

  def full_contact
    "#{full_name} #{'(' + phone + ')' unless phone.blank?}"
  end

  def available_between?(start_time, end_time)
    schedule.schedule_for_today.working_and_available?(DailySchedule::TimeRange.new(start_time, end_time))
  end

  def shifts
    roles= (self.roles.to_set & Set.new([:operator, :consultant, :trainer]))
    default_shifts = Setting["default_working_shifts"]
    roles.reduce(default_shifts['default']) do |ax, r|
      ax + default_shifts[r]
    end.uniq
  end

  def assign_roles_by(roles, manager)
    manageable_roles = manager == self ? manager.self_assignable_roles : manager.manageable_roles
    self.roles_mask = self.roles_mask ^ (User.mask_for(*manageable_roles) & (User.mask_for(*roles) ^ self.roles_mask))
  end

  def manageable_roles
    ability = Ability.new(self)
    self.class.valid_roles.select do |role|
      ability.can? :manage, role
    end
  end

  def self_assignable_roles
    ability = Ability.new(self)
    manageable_roles.select do |role|
      ability.can? :self_assign_role, role
    end
  end

  def subordinates
    User.with_any_role(*self.manageable_roles)
  end

  def weekly_schedules beginning_of_week
    self.schedule.weekly_schedules( beginning_of_week)
  end

  def add_appointment( appointment)
    daily_schedule = self.schedule.schedule_for appointment.date
    daily_schedule.add_appointment(appointment)
  end

  alias_method :original_schedule, :schedule
  def schedule
    schedule = self.original_schedule
    return schedule if schedule
    self.schedule = initialize_schedule
  end

  def performance options = {}
    assignments = self.assignments
    if since = options[:since]
      assignments = assignments.where(["created_at >= ?", since])
    end

    if til = options[:til]
      assignments = assignments.where(["created_at < ?", til])
    end

    if type = options[:type]
      assignments = assignments.where(:assignable_type => type)
    end

    assignments.reduce(0) do |result, assignment|
      result + assignment.assignable.try(:assignable_value){0}
    end
  end

  def trainer_performance options = {}
    performance options.merge(:type => "Participation")
  end

  def consultant_performance options = {}
    performance options.merge(:type => "Membership")
  end

  private
  def initialize_schedule
    schedule = Schedule.new
    schedule.user = self
    schedule.template = ScheduleTemplate.default
    schedule.save
    schedule
  end
end
