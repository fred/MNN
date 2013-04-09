ActiveAdmin.register CommentSubscription do
  config.sort_order = 'item_id_desc'
  menu parent: "Members", priority: 56, label: "Comment Subscriptions"
  # Filters
  filter :user
  filter :email
  filter :admin

  index title: "Comments" do
    id_column
    column :user do |t|
      if t.user
        link_to t.user.title.truncate(25), admin_user_path(t.user)
      end
    end
    column :item do |t|
      if t.item
        link_to t.item.title.truncate(50), admin_item_path(t.item)
      end
    end
    column "Started", :created_at, &->(t){t.created_at.to_s(:short)}
    default_actions
  end

  form do |f|
    f.inputs "Comment Subscription" do
      f.input :user_id, as: :number, label: "User ID"
      f.input :item_id, as: :number, label: "Item ID"
    end
    f.buttons
  end

  controller do
    def scoped_collection
      CommentSubscription.where("item_id is not NULL").includes(:user, :item)
    end
  end

end
