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
    where('upper(name) LIKE upper(:m) OR upper(phone) LIKE upper(:s) OR upper(mobile) LIKE upper(:s)', :s => "#{query}%", :m => "%#{query}%")
  }

  has_one :membership

  has_many :participations

  has_many :lessons, :through => :participations

  has_many :contracts

  has_many :account_visits do
    def last
      where(['`created_at` < ?', Time.now.beginning_of_day]).order('created_at DESC').first
    end
  end

  delegate :active?, :transferred?, :suspended?, :expired?, :to => :membership

  after_create do
    create_or_update_membership
  end

  belongs_to :lead

  belongs_to :trainer, :class_name => "User", :foreign_key => "trainer_id"

  def self.create_or_select_for(model, params, users)
    if model.account
      account = model.account
    else
      contract_params = params[:contracts_membership_contract]

      account = Account.new(params[:account])
      account.name = model.full_name
      [
        :gender, :dob, :nationality, :identification, :phone, :work_phone, :company,
        :emergency_contact_1, :emergency_contact_2, :email,
        :street1, :street2, :zipcode
      ].each do |attribute|
        account.send :"#{attribute}=", contract_params[attribute]
      end
      model.account = account
      if account.access != "Lead" || model.nil?
        account.save_with_permissions(users)
      else
        account.save_with_model_permissions(model)
      end
    end
    account
  end

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

end
