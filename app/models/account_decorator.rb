Account._validators.each do |key, value|
  if key == :name
    value.each do |validator|
      if validator.is_a? ActiveRecord::Validations::UniquenessValidator
        validator.attributes.delete(:name)
      end
    end
  end
end

Account.class_eval do
  scope :text_search, lambda { |query|
    query = query.gsub(/[^\w\s\-\.'\p{L}]/u, '').strip
    where('upper(name) LIKE upper(:m) OR upper(phone) LIKE upper(:s)', :s => "#{query}%", :m => "%#{query}%")
  }
  scope :state, lambda { |filters|
    includes(:membership).where('`memberships`.`status` IN (?)', filters)
  }

  validates_presence_of :nationality, :gender, :card_number, :identification

  has_one :membership

  has_many :participations

  has_many :lessons, :through => :participations

  has_many :contracts

  has_many :account_visits do
    def last
      where(['`created_at` < ?', Time.now.beginning_of_day]).order('created_at DESC').first
    end
  end

  has_many :account_surveys

  delegate :active?, :transferred?, :suspended?, :expired?, :to => :membership

  after_create do
    create_or_update_membership
  end

  belongs_to :lead

  belongs_to :trainer, :class_name => "User", :foreign_key => "trainer_id"

  before_save :update_name

  def participate_lesson params
    participation = Participation.new params[:participation]
    participation.account = self
    participation.times = participation.lesson.times
    participation.save
    participation
  end

  def create_or_update_membership(params = {})
    Membership.create_for(self, params)
  end

  def last_visit_time
    self.account_visits.last.try(:created_at)
  end

  def status
     if membership
       membership.status
     else
       "non_member"
      end
  end

  protected
  def update_name
    self.name = "#{self.first_name} #{self.last_name}"
  end
end
