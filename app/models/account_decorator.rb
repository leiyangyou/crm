Account.class_eval do
  has_one :membership

  delegate :normal?, :transferred?, :suspended?, :expired?, :to => :membership

  def create_or_update_membership(params)
    membership = self.membership
    unless membership
      membership = Membership.new(params)
      membership.account = self
    else
      if membership.should_accumulate_membership_duration?
        membership.duration += membership.type.duration #accumulate the previous membership
      end
      membership.update_attributes(params)
    end
    membership.due_date = membership.start_date + membership.type.duration
    membership
  end
end