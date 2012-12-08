# Comments Subscription
ActiveAdmin.register CommentSubscription do
  controller.authorize_resource
  config.comments = false
  menu parent: "Members", priority: 56, label: "Comment Subscriptions", if: lambda{|tabs_renderer|
    controller.current_ability.can?(:manage, CommentSubscription)
  }

  # Filters
  filter :user
  filter :email
  filter :admin

  index title: "Comments" do
    id_column
    column :user do |t|
      if t.user
        link_to t.user.title.truncate(40), admin_user_path(t.user)
      end
    end
    column :item do |t|
      if t.item
        link_to t.item.title, admin_item_path(t.item)
      end
    end
    column :email
    bool_column :admin
    column "Started", :created_at, &->(t){t.created_at.to_s(:short)}
    default_actions
  end

  form do |f|
    f.inputs "Comment Subscription" do
      f.input :user_id, as: :number, label: "User ID"
      f.input :item_id, as: :number, label: "Item ID"
      f.input :email
      f.input :admin
    end
    f.buttons
  end

  controller do
    def scoped_collection
       CommentSubscription.includes(:user, :item)
    end
  end

end