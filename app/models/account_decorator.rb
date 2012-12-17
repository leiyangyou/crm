Account.class_eval do
  scope :text_search, lambda { |query|
    query = query.gsub(/[^\w\s\-\.'\p{L}]/u, '').strip
    where('upper(name) LIKE upper(:m) OR upper(phone) LIKE upper(:s) OR upper(mobile) LIKE upper(:s)', :s => "#{query}%", :m => "%#{query}%")
  }

  has_one :membership

  has_many :participations

  has_many :lessons, :through => :participations

  delegate :active?, :transferred?, :suspended?, :expired?, :to => :membership

  after_create do
    create_or_update_membership
  end

  def participate_lesson params
    participation = Participation.new params[:participation]
    participation.account = self
    participation.times = participation.lesson.times
    participation.save
    participation
  end

  def create_or_update_membership(params = {})
    Membership.create_or_select_for(self, params)
  end

end
