# Comments
ActiveAdmin.register EmailDelivery do
  config.clear_sidebar_sections!
  controller.authorize_resource
  config.comments = false
  menu parent: "Items", priority: 14, label: "Email Delivery", if: lambda{|tabs_renderer|
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
  controller do
    def scoped_collection
       EmailDelivery.includes(:item)
    end
  end
end