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
      integer :registration_fee
      integer :membership_fee
      integer :discount
      integer :advance_payment
      integer :total_price
      integer :down_payment
      integer :amount_owed
    end

    belongs_to :consultant
    belongs_to :membership_type, :foreign_key => :type_id
    validates_presence_of :type_id, :consultant_id

    state_machine do
      state :signed do
        validates_presence_of :gender, :nationality, :identification, :dob, :street1, :card_number
      end
    end

    before_validation {
      (self.finished_on ||= (started_on + membership_type.duration.days)) if membership_type && started_on
    }

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
      account.membership.renewal self
    end

    def self.create_for(account, params)
      contract = self.new(params)
      contract.consultant_id = account.assigned_to
      contract.account = account
      contract.save
      contract
    end
  end
end