ActiveAdmin.register Subscription do
  config.sort_order = 'id_desc'
  menu parent: "Members", priority: 55, label: "Email Subscriptions"

  # Filters
  filter :user
  filter :email

  index title: "Email Subscriptions" do
    id_column
    column :user do |t|
      if t.user
        link_to t.user.title.truncate(25), admin_user_path(t.user)
      end
    end
    column :email
    column "Updated" do |t|
      t.updated_at.to_s(:short)
    end
    column "Created" do |t|
      t.created_at.to_s(:short)
    end
    default_actions
  end
  controller do
    def scoped_collection
      Subscription.where(item_id: nil).includes(:user)
    end
  end
end
