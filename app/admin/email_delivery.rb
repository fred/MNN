# Comments
ActiveAdmin.register EmailDelivery do
  controller.authorize_resource
  config.comments = false
  menu parent: "Members", priority: 57, label: "Email Delivery", if: lambda{|tabs_renderer|
    controller.current_ability.can?(:manage, EmailDelivery)
  }
  actions  :index, :destroy
  index do
    id_column
    column :item do |t|
      if t.item
        link_to t.item.title, admin_item_path(t.item)
      end
    end
    column :created_at
    column "Send Time", :send_at
    default_actions
  end
  
end