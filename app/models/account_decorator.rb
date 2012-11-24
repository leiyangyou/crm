Account.class_eval do
  has_one :membership

  delegate :active?, :transferred?, :suspended?, :expired?, :to => :membership

  after_create do
    create_or_update_membership
  end

  def create_or_update_membership(params = {})
    Membership.create_or_select_for(self, params)
  end
end
