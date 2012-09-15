# Item Subscription
ActiveAdmin.register Subscription do
  controller.authorize_resource
  config.comments = false
  menu parent: "Members", priority: 55, label: "Email Subscriptions", if: lambda{|tabs_renderer|
    controller.current_ability.can?(:manage, Subscription)
  }
  index title: "Email Subscriptions" do
    id_column
    column :user do |t|
      if t.user
        link_to t.user.title, admin_user_path(t.user)
      end
    end
    column :email
    column :updated_at
    column :created_at
    default_actions
  end
end
