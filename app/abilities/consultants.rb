Canard::Abilities.for(:consultant) do

  # Define abilities for the user role here. For example:
  #
  #   if user.admin?
  #     can :manage, :all
  #   else
  #     can :read, :all
  #   end
  #
  # The first argument to `can` is the action you are giving the user permission to do.
  # If you pass :manage it will apply to every action. Other common actions here are
  # :read, :create, :update and :destroy.
  #
  # The second argument is the resource the user can perform the action on. If you pass
  # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
  #
  # The third argument is an optional hash of conditions to further filter the objects.
  # For example, here the user can only update published articles.
  #
  #   can :update, Article, :published => true
  #
  # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  can :create, Lead
  can :show, Lead
  #can :index, Lead, :user_id => user.id
  #can :index, Lead, :assigned_to => user.id
  #can :filter, Lead, :user_id => user.id
  #can :filter, Lead, :assigned_to => user.id
  cannot :update_consultant, Lead
  cannot :update_consultant, Account
  cannot :update_trainer, Account
  cannot :filter_by_assigned_to, Lead
  cannot :filter_by_assigned_to, Account
  can :create, Account
  can :edit, Contracts::MembershipContract
  cannot :assign_any_consultant, Lead
  cannot :update_consultant, Lead
  cannot :destroy, Lead
end