Address.class_eval do
  after_initialize :set_default_country_and_state
  protected
  def set_default_country_and_state
    self.country = I18n.t(:china)
    self.state = I18n.t(:beijing)
    self.city = I18n.t(:beijing)
    self.zipcode = "100000"
  end
end