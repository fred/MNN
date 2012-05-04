# Comments
ActiveAdmin.register EmailDelivery do
  controller.authorize_resource
  config.comments = false
  menu parent: "Members", priority: 57, label: "Email Delivery", if: lambda{|tabs_renderer|
    controller.current_ability.can?(:manage, EmailDelivery)
  }
  actions  :index
  index do
    id_column
    # column :user do |t|
    #   if t.user
    #     link_to t.user.title, admin_user_path(t.user)
    #   end
    # end
    column :item do |t|
      if t.item
        link_to t.item.title, admin_item_path(t.item)
      end
    end
    column "Job Time", :send_at
    column :created_at
  end
  
end