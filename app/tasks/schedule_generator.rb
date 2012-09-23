class ScheduleGenerator

  SCHEDULABLE_ROLES = %w{operator consultant trainer}

  def generate( date)
    User.find_each do |user|
      if has_schedule?(user)
        template = template_for user
        template.apply_to(user, date)
      end
    end
  end

  def template_for user
    ScheduleTemplate.default
  end

  def has_schedule?(user)
    user.has_any_role?(SCHEDULABLE_ROLES)
  end
end