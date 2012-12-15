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

  after_create :initialize_schedule

  scope :manageable_by, (lambda do |user|
    where("#{role_mask_column} & :role_mask > 0 or users.id = :user_id", { :role_mask => mask_for(*user.manageable_roles), :user_id => user.id})
  end)

  def manageable_roles
    ability = Ability.new(self)
    self.class.valid_roles.select do |role|
      ability.can? :manage, role
    end
  end

  def subordinates
    User.with_any_role(*self.manageable_roles)
  end

  def weekly_schedules beginning_of_week
    self.schedule.weekly_schedules( beginning_of_week)
  end

  def available date, time_range
    User.include(:schedule).select{|user|
      daily_schedule = user.schedule.schedule_for(date)
      daily_schedule.available? time_range
    }
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
    assignments = assignments.where(["created_at >?", since]) if since = options[:since]
    assignments = assignments.where(:assignable_type => type) if type = options[:type]
    assignments.reduce(0) do |result, assignment|
      result + assignment.assignable.try(:assignable_value){0}
    end
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
