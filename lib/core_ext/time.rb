class Time
  def compare_time time
    self.since_beginning_of_the_day - time.since_beginning_of_the_day
  end
  def since_beginning_of_the_day
    self - self.beginning_of_day
  end
end