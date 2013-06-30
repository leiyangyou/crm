Task.class_eval do
  scope :related_to_user, lambda { |user|
    where(user.primary_roles.map {|role|
        "related_to_#{role} = 1"
      }.join(" OR ")
    )
  }

  before_save do
    if (assignee = self.assignee)
      self.related_to_trainer =  assignee.roles.include?(:trainer)
      self.related_to_consultant =  assignee.roles.include?(:consultant)
    end
    true
  end

  def parse_calendar_date
    DateTime.strptime(self.calendar,
                      '%Y-%m-%d %H:%M %p').utc
  end
end