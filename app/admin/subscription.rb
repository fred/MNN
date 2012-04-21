# Comments
ActiveAdmin.register Subscription do
  config.comments = false
  menu :parent => "Members", :priority => 55, :label => "Email Subscriptions"
  index do
    id_column
    column :user do |t|
      if t.user
        link_to t.user.title, admin_user_path(t.user)
      end
    end
    # column :item do |t|
    #   if t.item
    #     link_to t.item.title, admin_item_path(t.item)
    #   end
    # end
    column :email
    column :updated_at
    column :created_at
    default_actions
  end
  
end