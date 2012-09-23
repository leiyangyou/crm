User.class_eval do
  acts_as_user :roles => [:operator,
                          :operator_manager,
                          :consultant,
                          :consultant_manager,
                          :trainer,
                          :trainer_manager,
                          :general_manager,
                          :admin]
  attr_protected :roles

  scope :manageable_by, (lambda do |user|
    where("#{role_mask_column} & :role_mask > 0 or users.id = :user_id", { :role_mask => mask_for(*user.manageable_roles), :user_id => user.id})
  end)

  def manageable_roles
    ability = Ability.new(self)
    self.class.valid_roles.select do |role|
      ability.can? :manage, role
    end
  end
end