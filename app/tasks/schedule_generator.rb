class ScheduleGenerator

  SCHEDULABLE_ROLES = %w{operator consultant trainer}

  def generate( date)
    User.find_each do |user|
      if has_schedule?(user)
        template = user.schedule_template
        template.apply_to(user, date).save
      end
    end
  end

  def has_schedule?(user)
    user.has_any_role?(SCHEDULABLE_ROLES)
  end
end