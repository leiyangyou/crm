module Contracts
  class MembershipContract < Contract
    serialize_attributes :data, :blob => :parameters do
      integer :consultant_id, :required => true
      integer :type_id, :required => true
      integer :gender, :required => true
      string :nationality, :required => true
      string :identification, :required => true
      date :dob, :required => true
      string :company
      string :street1
      string :street2
      string :zipcode
      string :phone
      string :work_phone
      string :emergency_contact_1
      string :emergency_contact_2
      string :email
      string :card_number
      float :registration_fee
      float :membership_fee
      float :discount
      float :advance_payment
      float :total_price
      float :down_payment
    end

    belongs_to :consultant
    belongs_to :membership_type, :foreign_key => :type_id

    validates_presence_of :type_id, :consultant_id, :account_id

    state_machine :status do
      before_transition :to => :signed do |record|
       record.send :copy_attributes_from_account
      end

      state :signed do
        validates_presence_of :gender, :nationality, :identification, :dob, :street1, :card_number
      end
    end

    before_validation {
      unless self.signed? || !self.account
        copy_attributes_from_account
      end
    }

    def payment_completed?
      (total_price - down_payment) > 0 if total_price && down_payment
    end

    def gender_text
      I18n.t(gender == 0 ? :male : :female)
    end

    def club_name
      Setting[:club_name]
    end

    def consultant_name
      consultant && consultant.name
    end

    def membership_type_name
      membership_type && membership_type.name
    end

    def signed
      account.membership.renew self
    end

    def self.create_for(account, params)
      contract = self.new(params)
      contract.account = account
      contract.save
      contract
    end

    def abstract
      "#{I18n.t(:membership_type)} #{membership_type_name}"
    end

    protected
    def copy_attributes_from_account
      (self.finished_on ||= (started_on + membership_type.duration.days)) if membership_type && started_on
      self.consultant_id = self.account.assigned_to
      [ :gender, :nationality, :identification, :dob, :company, :street1, :street2, :zipcode,
        :phone, :work_phone, :emergency_contact_1, :emergency_contact_2, :email, :card_number].each do |attr|
        self.send :"#{attr}=", self.account.send(attr.to_sym)
      end
    end
  end
end