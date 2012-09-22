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

  scope :manageable_by, (lambda do |user|
    where("#{role_mask_column} & :role_mask > 0 or users.id = :user_id", { :role_mask => mask_for(*user.manageable_roles), :user_id => user.id})
  end)

  def manageable_roles
    ability = Ability.new(self)
    self.class.valid_roles.select do |role|
      ability.can? :manage, role
    end
  end

  def subordinates(with_self=true)
    subordinates = User.with_any_role(self.manageable_roles)
    subordinates.unshift(self) if with_self
  end

  class << self
    def available_for date_time
      Schedule.for_date(date_time.to_date).select{|schedule| schedule.available?(date_time)}
    end
  end
end
