User.class_eval do
  ROLES = [:operator,
           :operator_manager,
           :consultant,
           :consultant_manager,
           :trainer,
           :trainer_manager,
           :general_manager,
           :admin]
  acts_as_user :roles => ROLES
  attr_protected :roles

  has_many :schedules

  has_many :slots, :through => :schedules

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
    User.with_any_role(self.manageable_roles)
  end

  def find_or_create_schedule_by_week( date)
    date = date.jewish_beginning_of_week
    schedule = schedules.for_date( date).first || self.schedule_template.apply_to(self, date)
    schedule.save!
    schedule
  end

  def schedule_template
    ScheduleTemplate.default
  end
end
