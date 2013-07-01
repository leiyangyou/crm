Canard::Abilities.for(:trainer_manager) do

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

  can :manage, :something
  can :manage, :trainer
  can :manage, Lesson
  can :manage, Schedule
  can :manage, UserRank, :type => "trainer"
  can :manage, Lead
  can :manage, Account
  cannot :update_consultant, Lead
  cannot :convert, Lead

  cannot :self_assign_role, :trainer_manager

  can :manage, User do |user|
    user.roles.all? do |role|
      can? :manage, role
    end
  end
end
