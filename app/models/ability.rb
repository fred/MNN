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
    
    user ||= User.new
    # case user.role
    # when user.has_role? :admin
    #   can :manage, :all
    # when user.has_role? :editor
    #   can :manage, Post
    #   cannot [:destroy,:edit], Post
    # end
    
    # can :manage, :all
    
    # Can Manage Everything
    if user.has_role? :admin
      can :manage, :all
    end
      
    if user.has_role? :moderator
      can :manage, Comment
    end
    
    # Editor can manager all Items, Tags and Categories, 
    if user.has_role? :editor
      can :manage, [ItemStat,Version,Item,Tag,Category,Page,Language,
        Attachment,CommentSubscription,Subscription,EmailDelivery
      ]
      can :read, [ItemStat,Version]
    end
    
    # Authors can create, and edit/delete own articles
    # also read most of other resources.
    if user.has_role? :author
      can :read,    Item, :draft => false
      can :update,  Item, :user_id => user.id
      can :destroy, Item, :user_id => user.id
      can :create,  Item
      can [:read, :create], Attachment
      can :read,    [ItemStat,Category,Tag,Language,Version]
    end
    
    # Security Role
    if user.has_role? :security
      can :manage, [Role,User,AdminUser,ItemStat,Language,Version,
          Contact,CommentSubscription,Subscription,EmailDelivery,
          TwitterShare,Attachment
      ]
    end
    
    # A Reader can read all items that are not draft
    # A Reader can read all other records
    if user.has_role? :reader
      can :read, Item, :draft => false
      can :read, [Attachment,ItemStat,Category,Tag,Language,Version]
    end
    
    # Readers can manage own items
    if user.has_role? :basic
      can :read, [Tag,Category,Attachment,Score,Item,Language,Page,ItemStat,Version]
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
