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
end