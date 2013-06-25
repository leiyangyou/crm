Task.class_eval do
  scope :related_to_user, lambda { |user|
    where(user.primary_roles.map {|role|
        "related_to_#{role} = 1"
      }.join(" OR ")
    )
  }

  before_save do
    if self.assignee?
      self.related_to_trainer =  self.assignee.roles.include?(:trainer)
      self.related_to_consultant =  self.assignee.roles.include?(:consultant)
    end
  end
end