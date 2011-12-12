class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
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
    
    if user
      can :access, :rails_admin
      if user
        can :manage, :all
      elsif user.has_role? :admin
        can :manage, :all
      elsif user.has_role? :publisher
        can :manage, [Item]
      elsif user.has_role? :destroyer
        can :delete, [Item]
      elsif user.has_role? :editor
        can :manage, [Item]
      elsif user.has_role? :writer
        can :manage, [Item]
      elsif user.has_role? :reader
        can :read, :all
      elsif user.has_role? :user
        can :read, [Item]
      end
    end
    
    # Role.create!(:title => "Admin", :description => "Only For Administration Purposes")
    # Role.create!(:title => "Publisher", :description => "Publish Articles to Main Site")
    # Role.create!(:title => "Destroyer", :description => "Delete Others Articles")
    # Role.create!(:title => "Editor", :description => "Edit Others Articles")
    # Role.create!(:title => "Writer", :description => "Create New Articles")
    # Role.create!(:title => "Reader", :description => "Can Read all Articles")
    # Role.create!(:title => "User", :description => "Can Read, Edit and Delete own Articles")
    
  end
end
