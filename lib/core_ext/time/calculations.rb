class Time
  def jewish_beginning_of_week
    days_to_sunday = self.wday
    (self - days_to_sunday.days).midnight
  end

  def jewish_end_of_week
    days_to_saturday = 6 - self.wday
    (self + days_to_saturday.days).end_of_day
  end
end