class Ability
  include CanCan::Ability

  def initialize(user)
    
    user ||= User.new
    
    if user.has_role? :admin
      can :manage, :all
    end
      
    if user.has_role? :moderator
      can :manage, Comment
    end

    if user.has_role? :editor
      can :manage, [ItemStat,Version,Item,Tag,Category,Page,Language,
        Attachment,CommentSubscription,Subscription,EmailDelivery,
        Document,Link
      ]
      can :read, [ItemStat,Version,SearchQuery,PageView,FeedSite,FeedEntry]
    end

    if user.has_role? :author
      can :read,    Item
      can :update,  Item, user_id: user.id, draft: true
      can :destroy, Item, user_id: user.id, draft: true
      can :create,  Item
      can [:read, :create], Attachment
      can :read,    [ItemStat,Category,Tag,Language,Version,Page,Document,SearchQuery,FeedSite,FeedEntry]
    end

    if user.has_role? :security
      can :manage, [Role,User,AdminUser,ItemStat,Language,Version,
          Contact,CommentSubscription,Subscription,EmailDelivery,
          TwitterShare,FacebookShare,Attachment,Document,Link,SearchQuery,
          FeedSite,FeedEntry,PageView
      ]
    end

    if user.has_role? :reader
      can :read, Item, draft: false
      can :read, [Attachment,ItemStat,Category,Tag,Language,Version,Document,FeedSite,FeedEntry]
    end

    if user.has_role? :basic
      can :read, [Tag,Category,Attachment,Score,Item,Language,Page,ItemStat,Version,Document]
    end

    # cannot [:update, :destroy], Item, Item.where(protected: true) do |item|
    #   item.protected? && (item.user_id != user.id)
    # end
  end
end
