Canard::Abilities.for(:operator) do

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
  can :index, Lead
  can :read, Lead
  can :update, Lead
  can :filter, Lead
  can :index, Account
  can :filter, Account
  can :show, Account
  can :update, Account
  can [:edit, :sign], Contracts::MembershipContract
  cannot :manage_survey, Lead
  cannot :manage_survey, Account
  cannot :convert, Lead
  cannot :reject, Lead
  cannot :destroy, Lead
  cannot :update_consultant, Lead
end