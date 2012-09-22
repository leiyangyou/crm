class ScheduleTemplate::AttributesBuilder

  def initialize
    @attributes = {}
  end

  def default
    @attributes[:default] = true
    self
  end

  def with_user_id( user_id)
    @attributes[:user_id] = user_id
  end

  def with_role( role)
    @attributes[:role] = role
  end

  def build
    @attributes
  end
end